//
//  MockNetworkService.swift
//  CryptoExchangeApp
//
//  Created by Gustavo Ramalho on 25/11/25.
//


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
        // Simular delay de rede
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.shouldReturnError {
                completion(.failure(self.errorToReturn))
                return
            }
            
            // Determinar qual mock retornar baseado no endpoint
            let mockData: Data
            
            if endpoint.contains("/cryptocurrency/listings/latest") {
                mockData = self.createMockCryptocurrencyListResponse()
            } else if endpoint.contains("/exchange/info") {
                mockData = self.createMockExchangeInfoResponse()
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
    
    private func createMockCryptocurrencyListResponse() -> Data {
        let json = """
        {
            "data": [
                {
                    "id": 1,
                    "name": "Bitcoin",
                    "symbol": "BTC",
                    "slug": "bitcoin",
                    "cmc_rank": 1,
                    "num_market_pairs": 10000,
                    "circulating_supply": 19500000,
                    "total_supply": 19500000,
                    "max_supply": 21000000,
                    "infinite_supply": false,
                    "last_updated": "2024-01-01T00:00:00.000Z",
                    "date_added": "2013-04-28T00:00:00.000Z",
                    "tags": ["mineable", "pow"],
                    "platform": null,
                    "quote": {
                        "USD": {
                            "price": 50000.00,
                            "volume_24h": 30000000000,
                            "volume_change_24h": 5.2,
                            "percent_change_1h": 0.5,
                            "percent_change_24h": 2.3,
                            "percent_change_7d": 10.5,
                            "market_cap": 975000000000,
                            "market_cap_dominance": 45.0,
                            "fully_diluted_market_cap": 1050000000000,
                            "last_updated": "2024-01-01T00:00:00.000Z"
                        }
                    }
                },
                {
                    "id": 1027,
                    "name": "Ethereum",
                    "symbol": "ETH",
                    "slug": "ethereum",
                    "cmc_rank": 2,
                    "num_market_pairs": 8000,
                    "circulating_supply": 120000000,
                    "total_supply": 120000000,
                    "max_supply": null,
                    "infinite_supply": true,
                    "last_updated": "2024-01-01T00:00:00.000Z",
                    "date_added": "2015-08-07T00:00:00.000Z",
                    "tags": ["smart-contracts"],
                    "platform": null,
                    "quote": {
                        "USD": {
                            "price": 3000.00,
                            "volume_24h": 15000000000,
                            "volume_change_24h": 3.1,
                            "percent_change_1h": 0.2,
                            "percent_change_24h": 1.5,
                            "percent_change_7d": 8.2,
                            "market_cap": 360000000000,
                            "market_cap_dominance": 18.0,
                            "fully_diluted_market_cap": 360000000000,
                            "last_updated": "2024-01-01T00:00:00.000Z"
                        }
                    }
                },
                {
                    "id": 825,
                    "name": "Tether",
                    "symbol": "USDT",
                    "slug": "tether",
                    "cmc_rank": 3,
                    "num_market_pairs": 12000,
                    "circulating_supply": 90000000000,
                    "total_supply": 90000000000,
                    "max_supply": null,
                    "infinite_supply": true,
                    "last_updated": "2024-01-01T00:00:00.000Z",
                    "date_added": "2015-02-25T00:00:00.000Z",
                    "tags": ["stablecoin"],
                    "platform": null,
                    "quote": {
                        "USD": {
                            "price": 1.00,
                            "volume_24h": 50000000000,
                            "volume_change_24h": 0.5,
                            "percent_change_1h": 0.01,
                            "percent_change_24h": 0.02,
                            "percent_change_7d": 0.05,
                            "market_cap": 90000000000,
                            "market_cap_dominance": 5.0,
                            "fully_diluted_market_cap": 90000000000,
                            "last_updated": "2024-01-01T00:00:00.000Z"
                        }
                    }
                }
            ],
            "status": {
                "timestamp": "2024-01-01T00:00:00.000Z",
                "error_code": 0,
                "error_message": "",
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
                "1": {
                    "id": 1,
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
                "error_message": "",
                "elapsed": 10,
                "credit_count": 1
            }
        }
        """
        return json.data(using: .utf8)!
    }
}
