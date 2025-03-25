# Use an official Golang image as a build stage
FROM golang:1.23 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files for dependency management
COPY go.mod go.sum ./

# Download dependencies immediately - dependencies won't change frequently thus utilizing caching
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -installsuffix 'static' -o app-bin

# Use a minimal base image for production
FROM scratch

# Copy the binary and other files from the builder stage
COPY --from=builder /app/app-bin /app/app-bin
COPY --from=builder /app/templates /templates

# Command to run the executable
ENTRYPOINT ["/app/app-bin"]
