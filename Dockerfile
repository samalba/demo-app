# Build stage
	FROM golang:1.23 AS builder
	
	WORKDIR /app
	
	COPY go.mod go.sum ./
	RUN go mod download
	
	COPY *.go ./
	COPY ./templates ./templates
	RUN CGO_ENABLED=0 GOOS=linux go build -o /app/app-bin
	
	# Final stage
	FROM scratch
	COPY --from=builder /app/app-bin /app/app-bin
	ENTRYPOINT ["/app/app-bin"]