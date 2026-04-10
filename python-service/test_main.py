import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_fast_ping():
    response = client.get("/fast/ping")
    assert response.status_code == 200
    assert response.json() == {"message": "pong"}

def test_call_go_ping():
    # Этот тест требует запущенного Go сервиса
    # Если Go не запущен, тест должен падать с 503
    response = client.get("/call-go/ping")
    # Может быть 200 или 503, проверяем структуру
    if response.status_code == 200:
        assert "go_response" in response.json()
    else:
        assert response.status_code == 503

def test_call_go_hello():
    response = client.get("/call-go/hello/TestUser")
    if response.status_code == 200:
        data = response.json()
        assert "go_response" in data
        assert data["go_response"].get("hello") == "TestUser"
    else:
        assert response.status_code == 503
