# Use a multi-stage build to minimize the final image size.
FROM golang:1.23 AS builder

WORKDIR /app

# Cache dependencies early to avoid unnecessary repeats.
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Use CGO_ENABLED=0 for a static binary, which increases compatibility with scratch or distroless images.
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app-bin

# Use a minimal base image to reduce the size further and improve security.
FROM gcr.io/distroless/static

COPY --from=builder /app/app-bin /app/app-bin

# Distroless images default to CMD, thus using ENTRYPOINT is unnecessary unless we want a fixed command structure.
CMD ["/app/app-bin"]
