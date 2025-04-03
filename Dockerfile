FROM golang:1.23 AS builder

WORKDIR /app

# Combine copying of go.mod and go.sum with downloading dependencies
COPY go.mod go.sum ./
RUN go mod download

# Combine application source copy operations to minimize layers
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/app-bin

# Use a minimal base image for the final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates

# Copy the application from the builder stage
COPY --from=builder /app/app-bin /app/app-bin

ENTRYPOINT ["/app/app-bin"]
