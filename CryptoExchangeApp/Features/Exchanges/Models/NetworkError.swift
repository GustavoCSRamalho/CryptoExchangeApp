import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(statusCode: Int)
    case networkFailure(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return L10n.Error.Message.invalidURL
        case .noData:
            return L10n.Error.Message.noData
        case .decodingError:
            return L10n.Error.Message.decoding
        case .serverError(let code):
            return L10n.Error.Message.serverError(code)
        case .networkFailure(let error):
            return  L10n.Error.Message.network(error.localizedDescription)
        case .unknown:
            return L10n.Error.Message.unknown
        }
    }
}
