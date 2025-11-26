import Foundation

final class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError = false
    var errorToReturn: NetworkError = .unknown
    var mockData: Data?
    
    func request<T: Decodable>(
        endpoint: String,
        parameters: [String: Any]?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.shouldReturnError {
                completion(.failure(self.errorToReturn))
                return
            }
            
            let mockData: Data
            
            if endpoint.contains("/exchange/listings/latest") {
                mockData = self.createMockExchangeListingsResponse()
            } else if endpoint.contains("/exchange/info") {
                mockData = self.createMockExchangeInfoResponse()
            } else if endpoint.contains("/exchange/assets") {
                mockData = self.createMockExchangeAssetsResponse()
            } else {
                completion(.failure(.invalidURL))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(T.self, from: mockData)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }
    }
    
    private func createMockExchangeListingsResponse() -> Data {
        let json = """
        {
            "data": [
                {
                    "id": 270,
                    "name": "Binance",
                    "slug": "binance",
                    "num_market_pairs": 2000,
                    "spot_volume_usd": 15000000000.0,
                    "date_launched": "2017-07-14T00:00:00.000Z"
                },
                {
                    "id": 102,
                    "name": "Coinbase Exchange",
                    "slug": "coinbase-exchange",
                    "num_market_pairs": 500,
                    "spot_volume_usd": 2500000000.0,
                    "date_launched": "2015-01-20T00:00:00.000Z"
                },
                {
                    "id": 311,
                    "name": "Kraken",
                    "slug": "kraken",
                    "num_market_pairs": 800,
                    "spot_volume_usd": 1200000000.0,
                    "date_launched": "2013-09-10T00:00:00.000Z"
                }
            ],
            "status": {
                "timestamp": "2024-01-01T00:00:00.000Z",
                "error_code": 0,
                "error_message": null,
                "elapsed": 10,
                "credit_count": 1
            }
        }
        """
        return json.data(using: .utf8)!
    }
    
    private func createMockExchangeInfoResponse() -> Data {
        let json = """
        {
            "data": {
                "270": {
                    "id": 270,
                    "name": "Binance",
                    "slug": "binance",
                    "logo": "https://s2.coinmarketcap.com/static/img/exchanges/64x64/270.png",
                    "description": "Binance is a global cryptocurrency exchange that provides a platform for trading more than 100 cryptocurrencies.",
                    "date_launched": "2017-07-14T00:00:00.000Z",
                    "notice": null,
                    "countries": ["Malta"],
                    "fiats": ["USD", "EUR", "GBP"],
                    "tags": null,
                    "type": "centralized",
                    "maker_fee": 0.10,
                    "taker_fee": 0.10,
                    "weekly_visits": 5000000,
                    "spot_volume_usd": 15000000000,
                    "spot_volume_last_updated": "2024-01-01T00:00:00.000Z",
                    "urls": {
                        "website": ["https://www.binance.com"],
                        "twitter": ["https://twitter.com/binance"],
                        "blog": [],
                        "chat": ["https://t.me/binanceexchange"],
                        "fee": ["https://www.binance.com/fees.html"]
                    }
                }
            },
            "status": {
                "timestamp": "2024-01-01T00:00:00.000Z",
                "error_code": 0,
                "error_message": null,
                "elapsed": 10,
                "credit_count": 1
            }
        }
        """
        return json.data(using: .utf8)!
    }
    
    private func createMockExchangeAssetsResponse() -> Data {
        let json = """
        {
            "data": [
                {
                    "wallet_address": "0x5a52e96bacdabb82fd05763e25335261b270efcb",
                    "balance": 45000000,
                    "platform": {
                        "crypto_id": 1027,
                        "symbol": "ETH",
                        "name": "Ethereum"
                    },
                    "currency": {
                        "crypto_id": 5117,
                        "price_usd": 0.10241799413549,
                        "symbol": "OGN",
                        "name": "Origin Protocol"
                    }
                },
                {
                    "wallet_address": "0xf977814e90da44bfa03b6295a0616a897441acec",
                    "balance": 400000000,
                    "platform": {
                        "crypto_id": 1027,
                        "symbol": "ETH",
                        "name": "Ethereum"
                    },
                    "currency": {
                        "crypto_id": 5824,
                        "price_usd": 0.00251174724338,
                        "symbol": "SLP",
                        "name": "Smooth Love Potion"
                    }
                },
                {
                    "wallet_address": "0x5a52e96bacdabb82fd05763e25335261b270efcb",
                    "balance": 5588175,
                    "platform": {
                        "crypto_id": 1027,
                        "symbol": "ETH",
                        "name": "Ethereum"
                    },
                    "currency": {
                        "crypto_id": 3928,
                        "price_usd": 0.04813245442357,
                        "symbol": "IDEX",
                        "name": "IDEX"
                    }
                }
            ],
            "status": {
                "timestamp": "2024-01-01T00:00:00.000Z",
                "error_code": 0,
                "error_message": null,
                "elapsed": 10,
                "credit_count": 1
            }
        }
        """
        return json.data(using: .utf8)!
    }
}
