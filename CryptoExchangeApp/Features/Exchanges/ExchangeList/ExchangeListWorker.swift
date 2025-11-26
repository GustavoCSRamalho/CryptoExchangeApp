import Foundation

protocol ExchangesListWorkerProtocol {
    func fetchExchangeListings(completion: @escaping (Result<[ExchangeListing], NetworkError>) -> Void)
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
}
