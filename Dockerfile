# Use an official Golang image as the build stage
FROM golang:1.23 AS builder

# Create and set the working directory
WORKDIR /app

# Cache dependencies by copying go.mod and go.sum first
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . ./

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o app-bin

# Use a minimal base image for the runtime
FROM gcr.io/distroless/static-debian12

# Copy the compiled Go binary from the builder stage
COPY --from=builder /app/app-bin /app/app-bin

# Use a non-root user for enhanced security
USER nonroot:nonroot

# Run the Go binary
ENTRYPOINT ["/app/app-bin"]
