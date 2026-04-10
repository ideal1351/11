.PHONY: build-go build-python build-rust build-all sizes buildx clean

# Сборка отдельных образов
build-go:
	docker build -t go-service:latest ./go-service

build-python:
	docker build -t python-service:latest ./python-service

build-rust:
	docker build -f rust-service/Dockerfile.musl -t rust-service:latest ./rust-service

build-all: build-go build-python build-rust

# Сравнение размеров
sizes:
	@./scripts/compare_sizes.sh

# Кросс-платформенная сборка
buildx:
	@./scripts/buildx_multiarch.sh

# Очистка
clean:
	docker rmi go-service:latest python-service:latest rust-service:latest 2>/dev/null || true
	docker buildx rm multiarch-builder 2>/dev/null || true

# Запуск всех сервисов через docker-compose
up:
	docker-compose up -d

down:
	docker-compose down

# Проверка мультиплатформенных образов
inspect:
	@echo "Информация о мультиплатформенных образах:"
	@echo "Go:"
	@docker buildx imagetools inspect ideal1351/go-service:latest 2>/dev/null || echo "  Образ не найден в registry"
	@echo ""
	@echo "Python:"
	@docker buildx imagetools inspect ideal1351/python-service:latest 2>/dev/null || echo "  Образ не найден в registry"
	@echo ""
	@echo "Rust:"
	@docker buildx imagetools inspect ideal1351/rust-service:latest 2>/dev/null || echo "  Образ не найден в registry"
