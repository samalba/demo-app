# Build stage
FROM golang:1.23 AS builder

WORKDIR /app

# Download dependencies and build the application
COPY go.mod go.sum ./
RUN go mod download && \
    mkdir -p ./templates
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -o app-bin

# Final stage
FROM alpine:3.20
LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="This is an optimized image"

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the compiled Go binary
COPY --from=builder /app/app-bin .

ENTRYPOINT ["./app-bin"]