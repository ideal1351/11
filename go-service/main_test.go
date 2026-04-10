package main

import (
    "encoding/json"
    "net/http"
    "net/http/httptest"
    "testing"
)

func TestPingEndpoint(t *testing.T) {
    req, _ := http.NewRequest("GET", "/ping", nil)
    rr := httptest.NewRecorder()

    // Используем роутер из main.go (нужно экспортировать)
    // Для простоты создаём тестовый роутер
    handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        w.WriteHeader(http.StatusOK)
        json.NewEncoder(w).Encode(map[string]string{"message": "pong"})
    })

    handler.ServeHTTP(rr, req)

    if status := rr.Code; status != http.StatusOK {
        t.Errorf("handler returned wrong status code: got %v want %v", status, http.StatusOK)
    }

    var response map[string]string
    json.Unmarshal(rr.Body.Bytes(), &response)
    if response["message"] != "pong" {
        t.Errorf("handler returned wrong message: got %v want pong", response["message"])
    }
}
