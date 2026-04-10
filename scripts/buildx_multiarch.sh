#!/bin/bash

echo "=========================================="
echo "Кросс-платформенная сборка с docker buildx"
echo "=========================================="

# Проверяем наличие Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен"
    exit 1
fi

# Создаём и используем новый builder (если не существует)
if ! docker buildx ls | grep -q multiarch-builder; then
    echo "📦 Создание нового builder..."
    docker buildx create --name multiarch-builder --use
else
    echo "📦 Использование существующего builder..."
    docker buildx use multiarch-builder
fi

# Запускаем builder
echo "🚀 Запуск builder..."
docker buildx inspect --bootstrap

# Платформы для сборки
PLATFORMS="linux/amd64,linux/arm64"

echo ""
echo "=========================================="
echo "Сборка для платформ: $PLATFORMS"
echo "=========================================="

# Сборка Go образа
echo ""
echo "🔨 Сборка Go образа..."
docker buildx build \
  --platform $PLATFORMS \
  -t ideal1351/go-service:latest \
  -f go-service/Dockerfile \
  --push \
  ./go-service

if [ $? -eq 0 ]; then
    echo "✅ Go образ собран и отправлен"
else
    echo "❌ Ошибка сборки Go образа"
fi

# Сборка Python образа
echo ""
echo "🔨 Сборка Python образа..."
docker buildx build \
  --platform $PLATFORMS \
  -t ideal1351/python-service:latest \
  -f python-service/Dockerfile \
  --push \
  ./python-service

if [ $? -eq 0 ]; then
    echo "✅ Python образ собран и отправлен"
else
    echo "❌ Ошибка сборки Python образа"
fi

# Сборка Rust образа (с использованием musl Dockerfile)
echo ""
echo "🔨 Сборка Rust образа..."
docker buildx build \
  --platform $PLATFORMS \
  -t ideal1351/rust-service:latest \
  -f rust-service/Dockerfile.musl \
  --push \
  ./rust-service

if [ $? -eq 0 ]; then
    echo "✅ Rust образ собран и отправлен"
else
    echo "❌ Ошибка сборки Rust образа"
fi

echo ""
echo "=========================================="
echo "✅ Кросс-платформенная сборка завершена!"
echo "=========================================="
echo ""
echo "Собранные образы:"
echo "  - ideal1351/go-service:latest"
echo "  - ideal1351/python-service:latest"
echo "  - ideal1351/rust-service:latest"
echo ""
echo "Платформы: $PLATFORMS"
echo ""
echo "Для проверки:"
echo "  docker buildx imagetools inspect ideal1351/go-service:latest"
echo "  docker buildx imagetools inspect ideal1351/python-service:latest"
echo "  docker buildx imagetools inspect ideal1351/rust-service:latest"

# Опционально: очистка builder
# docker buildx rm multiarch-builder
