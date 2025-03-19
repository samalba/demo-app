# Use a specific and minimal Golang image for reduced size
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Consolidate commands to reduce layers
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app-bin

FROM scratch
COPY --from=builder /app/app-bin /app/app-bin
ENTRYPOINT ["/app/app-bin"]
