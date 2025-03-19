# Use Go official image as a build stage
FROM golang:1.23 as builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Cache Go modules
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o app-bin

# Final stage: minimal runtime image
FROM scratch
COPY --from=builder /app/app-bin /app/app-bin
COPY --from=builder /app/templates /templates

# Command to run the executable
ENTRYPOINT ["/app/app-bin"]
