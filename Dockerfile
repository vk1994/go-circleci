FROM golang:1.15.1-alpine AS builder
WORKDIR /build
ENV CGO_ENABLED=0 \
    TARGETOS=linux \
    TARGETARCH=amd64
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o main .
WORKDIR /dist
RUN cp /build/main .
FROM scratch
COPY --from=builder /dist/main /
# EXPOSE 8000
ENTRYPOINT [ "/main" ]