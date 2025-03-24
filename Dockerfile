# Start by pulling the full Go image to go module downloading & building statically linked binary
FROM golang:1.23 AS builder

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/app-bin

# Then, build the smaller image with only the necessary files
FROM scratch
COPY --from=builder /app/app-bin /app/app-bin
ENTRYPOINT ["/app/app-bin"]
