# Use an official Go image to create a build stage and keep it updated
FROM golang:1.23 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Cache the Go modules, which can be reused if no files have changed
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/app-bin

# Create a smaller deploy image using 'scratch'
FROM scratch

# Copy the Go binary and templates from the builder stage
COPY --from=builder /app/app-bin /app/app-bin
COPY --from=builder /app/templates /app/templates

# Command to run the executable
ENTRYPOINT ["/app/app-bin"]
