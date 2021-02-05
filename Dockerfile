FROM golang:1.15.8-alpine AS builder

WORKDIR /src
COPY . .

RUN go mod download && \
    CGO_ENABLED=0 go build -ldflags="-s -w" -o "release-bin"

FROM alpine:3.13.1

WORKDIR /

COPY --from=builder "/src/release-bin" "/deployer"

ENV GIN_MODE=release
ENTRYPOINT ["/deployer", "--port", "8080"]
EXPOSE 8080
