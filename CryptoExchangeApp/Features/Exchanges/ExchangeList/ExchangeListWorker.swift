import Foundation

protocol ExchangesListWorkerProtocol {
    func fetchExchangeListings(completion: @escaping (Result<[ExchangeListing], NetworkError>) -> Void)
    func fetchExchangeInfo(id: Int, completion: @escaping (Result<Exchange, NetworkError>) -> Void)

}

final class ExchangesListWorker: ExchangesListWorkerProtocol {
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
}
