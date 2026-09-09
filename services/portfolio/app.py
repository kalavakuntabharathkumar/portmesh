from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Portfolio Service")
holdings = {
    1: {"AAPL": {"quantity": 12, "avg_price": 180.0},
        "MSFT": {"quantity": 8, "avg_price": 410.0}}
}

class Holding(BaseModel):
    quantity: float
    avg_price: float

@app.get("/health")
def health():
    return {"service": "portfolio", "status": "ok"}

@app.get("/portfolios/{portfolio_id}/holdings")
def get_holdings(portfolio_id: int):
    return {"portfolio_id": portfolio_id, "holdings": holdings.get(portfolio_id, {})}

@app.get("/portfolios/{portfolio_id}/valuation")
def valuation(portfolio_id: int, prices: str = "AAPL:190,MSFT:420"):
    if portfolio_id not in holdings:
        raise HTTPException(404, "Portfolio not found")
    price_map = {}
    for item in prices.split(","):
        symbol, value = item.split(":")
        price_map[symbol] = float(value)
    rows = []
    total = 0.0
    for symbol, h in holdings[portfolio_id].items():
        market_price = price_map.get(symbol, h["avg_price"])
        value = h["quantity"] * market_price
        total += value
        rows.append({"symbol": symbol, "quantity": h["quantity"],
                     "price": market_price, "value": round(value,2)})
    return {"portfolio_id": portfolio_id, "total_value": round(total,2), "positions": rows}
