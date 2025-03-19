# Use an official Golang image as the build stage
FROM golang:1.23 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/app-bin

# Use a minimal image for the runtime stage
FROM gcr.io/distroless/static-debian11

# Copy the binary from the builder stage
COPY --from=builder /app/app-bin /app/app-bin

# Run the Go app
ENTRYPOINT ["/app/app-bin"]
