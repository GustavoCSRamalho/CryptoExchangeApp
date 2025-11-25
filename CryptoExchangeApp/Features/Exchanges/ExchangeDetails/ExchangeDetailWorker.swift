import Foundation

protocol ExchangeDetailWorkerProtocol {
    func fetchExchangeInfo(id: String, completion: @escaping (Result<Exchange, NetworkError>) -> Void)
}

final class ExchangeDetailWorker: ExchangeDetailWorkerProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchExchangeInfo(id: String, completion: @escaping (Result<Exchange, NetworkError>) -> Void) {
        let parameters: [String: Any] = [
            "id": id
        ]
        
        networkService.request(
            endpoint: "/exchange/info",
            parameters: parameters
        ) { (result: Result<ExchangeInfoResponse, NetworkError>) in
            switch result {
            case .success(let response):
                if let exchangeInfo = response.data[id] {
                    completion(.success(exchangeInfo))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
