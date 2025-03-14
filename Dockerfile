# Use the official Golang image as a builder
FROM golang:1.23 AS builder
WORKDIR /app

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source files and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app-bin

# Use a minimal base image
FROM gcr.io/distroless/static-debian11
COPY --from=builder /app/app-bin /app/app-bin

# Run the binary
ENTRYPOINT ["/app/app-bin"]
