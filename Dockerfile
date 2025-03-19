# Use official Golang image for building the application
FROM golang:1.23 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Cache the Go modules
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code into the container
COPY *.go ./
COPY ./templates ./templates

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/app-bin

# Use a minimal base image to package the application
FROM gcr.io/distroless/static:nonroot

# Copy the binary from the builder
COPY --from=builder /app/app-bin /app/app-bin

# Use a non-root user
USER nonroot:nonroot

# Command to run the executable
ENTRYPOINT ["/app/app-bin"]
