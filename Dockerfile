# Use the official Golang image as a builder
FROM golang:1.23 AS builder

# Set the working directory
WORKDIR /app

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy and build the application
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/app-bin

# Use a minimal base image
FROM scratch

# Copy the compiled binary from the builder
COPY --from=builder /app/app-bin /app/app-bin

# Use a non-root user to run the app
USER 1000

# Run the compiled Go binary
ENTRYPOINT ["/app/app-bin"]
