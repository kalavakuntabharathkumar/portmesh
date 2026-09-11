from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="Pricing Service")
prices = {"AAPL": 190.0, "MSFT": 420.0, "GOOGL": 175.0, "TSLA": 240.0}

class Price(BaseModel):
    symbol: str
    price: float

@app.get("/health")
def health():
    return {"service": "pricing", "status": "ok"}

@app.get("/prices")
def all_prices():
    return prices

@app.get("/prices/{symbol}")
def get_price(symbol: str):
    return {"symbol": symbol.upper(), "price": prices.get(symbol.upper())}

@app.post("/prices")
def set_price(item: Price):
    prices[item.symbol.upper()] = item.price
    return {"symbol": item.symbol.upper(), "price": item.price}
