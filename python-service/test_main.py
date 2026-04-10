import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_fast_ping():
    response = client.get("/fast/ping")
    assert response.status_code == 200
    assert response.json() == {"message": "pong"}

def test_health():
    response = client.get("/fast/ping")
    assert response.status_code == 200

def test_call_go_ping():
    # Тест может падать, если Go не запущен, но проверяем структуру
    response = client.get("/call-go/ping")
    if response.status_code == 200:
        assert "go_response" in response.json()
    else:
        assert response.status_code == 503
