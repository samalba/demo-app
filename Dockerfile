# Use the official Golang image as the builder
FROM golang:1.23 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files for dependency management
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/app-bin

# Use a minimal base image for the final output
FROM gcr.io/distroless/static:nonroot

# Copy the prebuilt binary from the builder
COPY --from=builder /app/app-bin /app/app-bin

# Use a non-root user for security
USER nonroot:nonroot

# Command to run the executable
ENTRYPOINT ["/app/app-bin"]
