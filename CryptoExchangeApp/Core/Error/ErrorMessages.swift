import Foundation

enum APIError {
    case badRequest(message: String?)
    case unauthorized
    case forbidden
    case tooManyRequests
    case internalServerError(statusCode: Int)
    case noData
    case decodingError
    case networkFailure(Error)
    case unknown
    
    var title: String {
        switch self {
        case .badRequest:
            return L10n.Error.Title.badRequest
        case .unauthorized:
            return L10n.Error.Title.unauthorized
        case .forbidden:
            return L10n.Error.Title.forbidden
        case .tooManyRequests:
            return L10n.Error.Title.rateLimit
        case .internalServerError:
            return L10n.Error.Title.serverError
        case .noData:
            return L10n.Error.Title.noData
        case .decodingError:
            return L10n.Error.Title.decoding
        case .networkFailure:
            return L10n.Error.Title.network
        case .unknown:
            return L10n.Error.Title.unknown
        }
    }
    
    var message: String {
        switch self {
        case .badRequest(let customMessage):
            return customMessage ?? L10n.Error.Message.badRequest
        case .unauthorized:
            return L10n.Error.Message.unauthorized
        case .forbidden:
            return L10n.Error.Message.forbidden
        case .tooManyRequests:
            return L10n.Error.Message.rateLimit
        case .internalServerError(let statusCode):
            return L10n.Error.Message.serverError(statusCode)
        case .noData:
            return L10n.Error.Message.noData
        case .decodingError:
            return L10n.Error.Message.decoding
        case .networkFailure(let error):
            return L10n.Error.Message.network(error.localizedDescription)
        case .unknown:
            return L10n.Error.Message.unknown
        }
    }
    
    var actionButtonTitle: String {
        switch self {
        case .tooManyRequests:
            return L10n.General.waitRetry
        case .unauthorized, .forbidden:
            return L10n.General.ok
        default:
            return L10n.General.retry
        }
    }
    
    var shouldShowRetry: Bool {
        switch self {
        case .unauthorized, .forbidden:
            return false
        default:
            return true
        }
    }
}

extension NetworkError {
    func toAPIError() -> APIError {
        switch self {
        case .invalidURL:
            return .badRequest(message: L10n.Error.Message.badRequest)
        case .noData:
            return .noData
        case .decodingError:
            return .decodingError
        case .serverError(let statusCode):
            switch statusCode {
            case 400:
                return .badRequest(message: L10n.Error.Message.badRequestId)
            case 401:
                return .unauthorized
            case 403:
                return .forbidden
            case 429:
                return .tooManyRequests
            case 500...599:
                return .internalServerError(statusCode: statusCode)
            default:
                return .unknown
            }
        case .networkFailure(let error):
            return .networkFailure(error)
        case .unknown:
            return .unknown
        }
    }
}
