# PROMPT_LOG — Лабораторная работа №11

**Студент:** Филатов Иван Игоревич  
**Группа:** 221331  
**Вариант:** 2  
**Дата выполнения:** 10.04.2026 – 11.04.2026

---

## Использованные AI-инструменты

| Инструмент | Версия | Назначение |
|------------|--------|------------|
| GitHub Copilot | Latest | Автодополнение кода, генерация Dockerfile |
| ChatGPT (DeepSeek) | R1 | Архитектурные решения, отладка, объяснение концепций |

---

## История промптов (ключевые запросы)

| № | Промпт | Ответ AI | Результат | Связанный коммит |
|---|--------|----------|-----------|------------------|
| 1 | "Как написать многоэтапный Dockerfile для Go с финальным образом scratch?" | Пример с `golang:alpine` → `scratch`, `CGO_ENABLED=0` | `go-service/Dockerfile` | `feat(medium2): add multi-stage Dockerfile for Go` |
| 2 | "Как сравнить размеры Docker образов в скрипте?" | Команды `docker images --format` | `scripts/compare_sizes.sh` | `bench: add size comparison script` |
| 3 | "Как настроить кастомную сеть в docker-compose?" | `networks` с `driver: bridge` и фиксированные IP | `docker-compose.yml` | `feat(medium6): add docker-compose` |
| 4 | "Как собрать Rust-приложение с musl для статической сборки?" | Использовать `clux/muslrust` или `alpine` + `musl-dev` | `rust-service/Dockerfile.musl` | `feat(hard2): add musl-based Dockerfile` |
| 5 | "Как настроить docker buildx для кросс-платформенной сборки?" | `buildx create --use`, `--platform linux/amd64,linux/arm64` | `scripts/buildx_multiarch.sh` | `feat(hard4): add buildx script` |

---

## Возникшие проблемы и их решение

| Проблема | Решение | Коммит |
|----------|---------|--------|
| Go-образ не запускался из-за отсутствия CA сертификатов | Добавлен `COPY --from=builder /etc/ssl/certs/ca-certificates.crt` | `feat(medium2)` |
| Rust-бинарник не был статически слинкован | Использован `--target x86_64-unknown-linux-musl` и образ `clux/muslrust` | `feat(hard2)` |
| `docker buildx` не работал без создания builder | Добавлен `docker buildx create --use` в скрипт | `feat(hard4)` |
| Python-образ был слишком большим | Использован `python:3.12-slim` вместо полного образа | `feat: add Dockerfile for Python` |

---

## Итоговая статистика

| Параметр | Значение |
|----------|----------|
| Всего промптов | 5 |
| Всего коммитов | 9 |
| Общее время работы | ~4 часа |
| Количество Dockerfile | 3 (Go, Python, Rust musl) |
| Размер Go образа | ~8 MB |
| Размер Python образа | ~180 MB |

---

## Ссылки на коммиты

| Коммит | Описание |
|--------|----------|
| `feat(medium2)` | Dockerfile для Go с многоэтапной сборкой |
| `bench` | Скрипт сравнения размеров образов |
| `feat(medium6)` | docker-compose с кастомной сетью |
| `feat(hard2)` | Rust Dockerfile с musl |
| `feat(hard4)` | docker buildx скрипт |

---

*Отчёт составлен в соответствии с требованиями методологии Agentic Engineering.*
