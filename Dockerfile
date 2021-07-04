FROM golang:latest as builder

WORKDIR /build
RUN adduser -u 10001 -D app-runner

ENV GOPROXY https://goproxy.cn,direct
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -a -o test_app .

FROM scratch as prod

WORKDIR /app
COPY --from=builder /build/test_app /app/

USER app-runner
ENTRYPOINT ["/app/test_app"]