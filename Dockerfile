# Stage 1: Build the application
FROM golang:1.23 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app-bin

# Stage 2: Run the application
FROM alpine:3.20 as runner
# Add a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/app-bin /app/app-bin

# Change permissions and switch to non-root user
RUN chmod +x /app/app-bin
USER appuser

ENTRYPOINT ["/app/app-bin"]
