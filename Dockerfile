FROM golang:1.20.1-alpine AS builder

WORKDIR /src
COPY . .

RUN apk add --no-cache git && \
    go mod download && \
    CGO_ENABLED=0 go build -ldflags="-s -w" -o "http-ci-deployer"

FROM alpine:3.17.2

WORKDIR /

COPY --from=builder "/src/http-ci-deployer" "/"

ENV GIN_MODE=release
ENTRYPOINT ["/http-ci-deployer", "--port", "8080"]
EXPOSE 8080
