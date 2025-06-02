# Stage 1: Test & Build
FROM golang:1.23.7-alpine3.21 as builder
WORKDIR /app
COPY app/ .
RUN go mod download
RUN go test -v ./... -coverprofile=coverage.out
RUN CGO_ENABLED=0 GOOS=linux go build -v -o main .

FROM alpine:latest as final
COPY --from=builder /app/main /main
ENTRYPOINT ["./main"]