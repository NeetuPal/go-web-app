FROM golang:1.22.5 AS builder

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

# Set environment variables for cross-compilation (Linux/ARM64)
RUN GOOS=linux GOARCH=amd64 go build -o main .

#RUN go build -o /main .

#final stage - distroless image
FROM gcr.io/distroless/base

COPY --from=builder app/main .

COPY --from=builder /app/static /static

EXPOSE 8080

CMD [ "./main" ]






 