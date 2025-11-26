import Foundation

protocol ExchangesWorkerProtocol {
    func fetchExchangeListings(completion: @escaping (Result<[ExchangeListing], NetworkError>) -> Void)
    func fetchExchangeInfo(id: Int, completion: @escaping (Result<Exchange, NetworkError>) -> Void)
    func fetchExchangeAssets(id: Int, completion: @escaping (Result<[ExchangeAsset], NetworkError>) -> Void)
}

final class ExchangesWorker: ExchangesWorkerProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchExchangeListings(completion: @escaping (Result<[ExchangeListing], NetworkError>) -> Void) {
        let parameters: [String: Any] = [
            "limit": 50,
            "sort": "volume_24h"
        ]
        
        networkService.request(
            endpoint: "/exchange/listings/latest",
            parameters: parameters
        ) { (result: Result<ExchangeListingsResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchExchangeInfo(id: Int, completion: @escaping (Result<Exchange, NetworkError>) -> Void) {
        let parameters: [String: Any] = [
            "id": id
        ]
        
        networkService.request(
            endpoint: "/exchange/info",
            parameters: parameters
        ) { (result: Result<ExchangeInfoResponse, NetworkError>) in
            switch result {
            case .success(let response):
                if let exchange = response.data.values.first {
                    completion(.success(exchange))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchExchangeAssets(id: Int, completion: @escaping (Result<[ExchangeAsset], NetworkError>) -> Void) {
        let parameters: [String: Any] = [
            "id": id
        ]
        
        networkService.request(
            endpoint: "/exchange/assets",
            parameters: parameters
        ) { (result: Result<ExchangeAssetsResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
