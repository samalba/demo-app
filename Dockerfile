# Build Stage
FROM golang:1.23 AS builder

WORKDIR /app

# Copy and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source code and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app-bin

# Final Stage
FROM alpine:3.20

# Copy the binary
COPY --from=builder /app/app-bin /app/app-bin

# Set entry point
ENTRYPOINT ["/app/app-bin"]
