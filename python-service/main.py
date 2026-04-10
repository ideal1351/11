from fastapi import FastAPI, HTTPException
import httpx

app = FastAPI()

GO_URL = "http://localhost:8080"

@app.get("/call-go/ping")
async def call_ping():
    async with httpx.AsyncClient() as client:
        try:
            resp = await client.get(f"{GO_URL}/ping")
            resp.raise_for_status()
            return {"go_response": resp.json()}
        except httpx.RequestError as e:
            raise HTTPException(status_code=503, detail=str(e))

@app.get("/call-go/hello/{name}")
async def call_hello(name: str):
    async with httpx.AsyncClient() as client:
        try:
            resp = await client.get(f"{GO_URL}/hello/{name}")
            resp.raise_for_status()
            return {"go_response": resp.json()}
        except httpx.RequestError as e:
            raise HTTPException(status_code=503, detail=str(e))

@app.get("/fast/ping")
async def fast_ping():
    return {"message": "pong"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
