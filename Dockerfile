# Use a smaller base image for the builder
FROM golang:alpine AS builder

# Install git for go module download
RUN apk add --no-cache git

WORKDIR /app

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o app-bin

# Use a minimal base image
FROM alpine:3.20

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/app-bin /app/app-bin

# Use non-root user
USER appuser

ENTRYPOINT ["/app/app-bin"]
