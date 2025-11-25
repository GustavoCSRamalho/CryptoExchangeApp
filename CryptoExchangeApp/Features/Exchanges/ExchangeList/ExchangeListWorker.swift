import Foundation

protocol ExchangesWorkerProtocol {
    func fetchCryptocurrencies(completion: @escaping (Result<[Cryptocurrency], NetworkError>) -> Void)
}

final class ExchangesWorker: ExchangesWorkerProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchCryptocurrencies(completion: @escaping (Result<[Cryptocurrency], NetworkError>) -> Void) {
        let parameters: [String: Any] = [
            "limit": 50,
            "sort": "market_cap",
            "sort_dir": "desc",
            "convert": "USD"
        ]
        
        networkService.request(
            endpoint: "/cryptocurrency/listings/latest",
            parameters: parameters
        ) { (result: Result<CryptocurrencyListResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
