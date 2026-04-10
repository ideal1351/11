#!/bin/bash

echo "=========================================="
echo "Сравнение размеров Docker образов"
echo "=========================================="
echo ""

# Сборка образов
echo "Сборка Go образа..."
docker build -t go-service:latest ./go-service

echo "Сборка Python образа..."
docker build -t python-service:latest ./python-service

echo ""
echo "=========================================="
echo "РАЗМЕРЫ ОБРАЗОВ"
echo "=========================================="

# Получаем размеры
GO_SIZE=$(docker images go-service:latest --format "{{.Size}}")
PYTHON_SIZE=$(docker images python-service:latest --format "{{.Size}}")

echo "| Сервис | Размер образа |"
echo "|--------|---------------|"
echo "| Go (scratch) | $GO_SIZE |"
echo "| Python (slim) | $PYTHON_SIZE |"

echo ""
echo "Вывод: Go образ значительно меньше Python образа"
echo "из-за статической компиляции и использования scratch."

# Сохраняем результаты
cat > results/sizes.txt << EOF
РЕЗУЛЬТАТЫ СРАВНЕНИЯ РАЗМЕРОВ ОБРАЗОВ
========================================
Go образ (scratch): $GO_SIZE
Python образ (slim): $PYTHON_SIZE

Вывод: Go образ меньше из-за:
1. Статическая компиляция без зависимостей
2. Базовый образ scratch (0 байт)
3. Отсутствие интерпретатора и лишних библиотек
