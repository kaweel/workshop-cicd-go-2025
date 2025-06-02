# Stage 1: Test & Build
FROM golang:1.24.3-alpine3.22 AS builder
WORKDIR /app
COPY app/ .
RUN go mod download
RUN go test -v ./... -coverprofile=coverage.out
RUN CGO_ENABLED=0 GOOS=linux go build -v -o main .

# Stage 2: Pack
FROM alpine:latest AS final
COPY --from=builder /app/coverage.out .
COPY --from=builder /app/main .
ENTRYPOINT ["./main"]