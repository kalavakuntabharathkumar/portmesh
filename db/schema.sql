CREATE TABLE assets (
  asset_id SERIAL PRIMARY KEY,
  symbol VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(120) NOT NULL
);

CREATE TABLE portfolios (
  portfolio_id SERIAL PRIMARY KEY,
  owner VARCHAR(120) NOT NULL
);

CREATE TABLE holdings (
  holding_id SERIAL PRIMARY KEY,
  portfolio_id INT NOT NULL REFERENCES portfolios(portfolio_id),
  asset_id INT NOT NULL REFERENCES assets(asset_id),
  quantity NUMERIC(20,6) NOT NULL CHECK (quantity >= 0),
  UNIQUE(portfolio_id, asset_id)
);

CREATE TABLE transactions (
  transaction_id SERIAL PRIMARY KEY,
  portfolio_id INT NOT NULL REFERENCES portfolios(portfolio_id),
  asset_id INT NOT NULL REFERENCES assets(asset_id),
  side VARCHAR(10) NOT NULL CHECK (side IN ('BUY','SELL')),
  quantity NUMERIC(20,6) NOT NULL CHECK (quantity > 0),
  price NUMERIC(20,6) NOT NULL CHECK (price >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE prices (
  price_id SERIAL PRIMARY KEY,
  asset_id INT NOT NULL REFERENCES assets(asset_id),
  price NUMERIC(20,6) NOT NULL CHECK (price >= 0),
  priced_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE valuation_snapshots (
  snapshot_id SERIAL PRIMARY KEY,
  portfolio_id INT NOT NULL REFERENCES portfolios(portfolio_id),
  total_value NUMERIC(20,6) NOT NULL,
  captured_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_holdings_portfolio ON holdings(portfolio_id);
CREATE INDEX idx_holdings_asset ON holdings(asset_id);
CREATE INDEX idx_transactions_portfolio_time ON transactions(portfolio_id, created_at);
CREATE INDEX idx_prices_asset_time ON prices(asset_id, priced_at DESC);
CREATE INDEX idx_snapshots_portfolio_time ON valuation_snapshots(portfolio_id, captured_at DESC);
