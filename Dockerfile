FROM golang:1.22-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache git

# Copy only dependency files first to leverage Docker cache
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY *.go ./
COPY ./templates ./templates

# Build with security flags
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/app-bin

# Use a specific alpine version 
FROM alpine:3.18

# Install CA certificates for HTTPS connections
RUN apk add --no-cache ca-certificates

# Create app directory with proper permissions
WORKDIR /app

# Copy only the compiled binary from builder
COPY --from=builder /app/app-bin /app/app-bin

# Set executable permissions on the binary
RUN chmod +x /app/app-bin

# Add non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Run the binary
ENTRYPOINT ["/app/app-bin"]