#!/bin/bash

echo "=========================================="
echo "Кросс-платформенная сборка с docker buildx"
echo "=========================================="

# Создаём новый builder
docker buildx create --name multiarch-builder --use

# Запускаем builder
docker buildx inspect --bootstrap

# Сборка Go образа для нескольких платформ
echo "Сборка Go образа для linux/amd64, linux/arm64..."
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t go-service:multiarch \
  --load \
  ./go-service

# Сборка Rust образа для нескольких платформ
echo "Сборка Rust образа для linux/amd64, linux/arm64..."
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -f rust-service/Dockerfile.musl \
  -t rust-service:multiarch \
  --load \
  ./rust-service

echo ""
echo "✅ Кросс-платформенные образы собраны!"
echo "Проверка:"
docker images | grep multiarch

# Очистка builder (опционально)
# docker buildx rm multiarch-builder
