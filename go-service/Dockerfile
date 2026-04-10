# Этап 1: сборка
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Копируем go.mod и скачиваем зависимости
COPY go.mod go.sum ./
RUN go mod download

# Копируем исходный код
COPY main.go .

# Собираем статический бинарный файл
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o server main.go

# Этап 2: финальный образ (scratch)
FROM scratch

WORKDIR /app

# Копируем бинарный файл из builder
COPY --from=builder /app/server /server

# Копируем CA сертификаты (для HTTPS запросов, если нужны)
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8080

CMD ["/server"]
