# Use a more specific base image with just the necessary tools for building
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Group COPY commands to minimize the number of layers
COPY go.mod go.sum ./
RUN go mod download

# Minimize the layers by combining COPY and the build command in one layer
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app-bin

# Ensure security by using a distroless base image for the final image
FROM gcr.io/distroless/static-debian11
COPY --from=builder /app/app-bin /app/app-bin
USER nonroot:nonroot
ENTRYPOINT ["/app/app-bin"]
