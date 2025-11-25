import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: String,
        parameters: [String: Any]?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://pro-api.coinmarketcap.com/v1"
    private let apiKey = "e51fac2edb984145a787759b7d79a4fe"
    
    func request<T: Decodable>(
        endpoint: String,
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let url = baseURL + endpoint
        
        let headers: HTTPHeaders = [
            "X-CMC_PRO_API_KEY": apiKey,
            "Accept": "application/json"
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: parameters,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    completion(.failure(.serverError(statusCode: statusCode)))
                } else {
                    completion(.failure(.networkFailure(error)))
                }
            }
        }
    }
}
