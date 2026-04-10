package main

import (
    "log"
    "time"
    "github.com/gin-gonic/gin"
)

// Middleware для логирования
func loggerMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        start := time.Now()
        c.Next()
        duration := time.Since(start)
        log.Printf("[%s] %s %s - %d (%v)",
            c.Request.Method,
            c.Request.URL.Path,
            c.ClientIP(),
            c.Writer.Status(),
            duration,
        )
    }
}

func main() {
    r := gin.Default()
    r.Use(loggerMiddleware())

    r.GET("/ping", func(c *gin.Context) {
        c.JSON(200, gin.H{"message": "pong"})
    })
    r.GET("/hello/:name", func(c *gin.Context) {
        name := c.Param("name")
        c.JSON(200, gin.H{"hello": name})
    })

    r.Run(":8080")
}