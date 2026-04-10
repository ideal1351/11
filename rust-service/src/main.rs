use axum::{
    routing::get,
    response::Json,
    Router,
};
use serde_json::json;
use std::net::SocketAddr;

async fn ping() -> Json<serde_json::Value> {
    Json(json!({"message": "pong from Rust"}))
}

async fn health() -> Json<serde_json::Value> {
    Json(json!({"status": "ok", "service": "rust-service"}))
}

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/ping", get(ping))
        .route("/health", get(health));

    let addr = SocketAddr::from(([0, 0, 0, 0], 8082));
    println!("Rust service listening on {}", addr);

    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}
