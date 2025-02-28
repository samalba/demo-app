# syntax=docker/dockerfile:1

# Build stage
FROM golang:1.22-alpine AS builder

# Add security updates and create non-root user
RUN apk update && apk upgrade && \
    adduser -D -g '' appuser

WORKDIR /app

# Copy only the files needed for downloading dependencies first
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY *.go ./
COPY ./templates ./templates

# Build the application with security flags
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" \
    -o /app/app-bin

# Final stage
FROM alpine:3.19

# Add security updates and CA certificates
RUN apk update && apk upgrade && \
    apk add --no-cache ca-certificates && \
    rm -rf /var/cache/apk/* && \
    adduser -D -g '' appuser

# Copy the binary from builder
COPY --from=builder /app/app-bin /app/app-bin

# Use non-root user
USER appuser

# Set the binary as entrypoint
ENTRYPOINT ["/app/app-bin"]