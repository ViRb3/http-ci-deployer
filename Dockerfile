FROM golang:1.17.3-alpine AS builder

WORKDIR /src
COPY . .

RUN go mod download && \
    CGO_ENABLED=0 go build -ldflags="-s -w" -o "http-ci-deployer"

FROM alpine:3.14.3

WORKDIR /

COPY --from=builder "/src/http-ci-deployer" "/"

ENV GIN_MODE=release
ENTRYPOINT ["/http-ci-deployer", "--port", "8080"]
EXPOSE 8080
