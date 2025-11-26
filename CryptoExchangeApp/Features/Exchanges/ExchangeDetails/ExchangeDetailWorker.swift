import Foundation

protocol ExchangeDetailWorkerProtocol {
    func fetchExchangeInfo(id: Int, completion: @escaping (Result<Exchange, NetworkError>) -> Void)
    func fetchExchangeAssets(id: Int, completion: @escaping (Result<[ExchangeAsset], NetworkError>) -> Void)
}

final class ExchangeDetailWorker: ExchangeDetailWorkerProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
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
                if let exchangeInfo = response.data.values.first {
                    completion(.success(exchangeInfo))
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
