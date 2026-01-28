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
    private let baseURL = APIConstants.baseURL
    private let apiKey = APIConstants.apiKey
    
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
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let decodedResponse):
                completion(.success(decodedResponse))
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    completion(.failure(.serverError(statusCode: statusCode)))
                } else if error.isResponseSerializationError {
                    completion(.failure(.decodingError))
                } else {
                    completion(.failure(.networkFailure(error)))
                }
            }
        }
    }
}
