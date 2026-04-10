package main

import (
    "encoding/json"
    "net/http"
    "net/http/httptest"
    "testing"
    "github.com/gin-gonic/gin"
)

func TestPingEndpoint(t *testing.T) {
    gin.SetMode(gin.TestMode)
    router := gin.Default()
    router.GET("/ping", func(c *gin.Context) {
        c.JSON(200, gin.H{"message": "pong"})
    })

    req, _ := http.NewRequest("GET", "/ping", nil)
    w := httptest.NewRecorder()
    router.ServeHTTP(w, req)

    if w.Code != http.StatusOK {
        t.Errorf("Expected status 200, got %d", w.Code)
    }

    var response map[string]string
    json.Unmarshal(w.Body.Bytes(), &response)
    if response["message"] != "pong" {
        t.Errorf("Expected message 'pong', got '%s'", response["message"])
    }
}

func TestHelloEndpoint(t *testing.T) {
    gin.SetMode(gin.TestMode)
    router := gin.Default()
    router.GET("/hello/:name", func(c *gin.Context) {
        name := c.Param("name")
        c.JSON(200, gin.H{"hello": name})
    })

    req, _ := http.NewRequest("GET", "/hello/World", nil)
    w := httptest.NewRecorder()
    router.ServeHTTP(w, req)

    if w.Code != http.StatusOK {
        t.Errorf("Expected status 200, got %d", w.Code)
    }

    var response map[string]string
    json.Unmarshal(w.Body.Bytes(), &response)
    if response["hello"] != "World" {
        t.Errorf("Expected hello 'World', got '%s'", response["hello"])
    }
}
