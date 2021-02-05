FROM golang:1.15.7-alpine AS builder

WORKDIR /src
COPY . .

RUN go mod download && \
    CGO_ENABLED=0 go build -ldflags="-s -w" -o "release-bin"

FROM alpine:3.11

WORKDIR /

COPY --from=builder "/src/release-bin" "/deployer"

ENV GIN_MODE=release
ENTRYPOINT ["/deployer", "--port", "8080"]
EXPOSE 8080
