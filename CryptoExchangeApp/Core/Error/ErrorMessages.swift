import Foundation

enum APIError {
    case badRequest(message: String?)
    case unauthorized
    case forbidden
    case tooManyRequests
    case internalServerError
    case noData
    case decodingError
    case networkFailure(Error)
    case unknown
    
    var title: String {
        switch self {
        case .badRequest:
            return "Invalid Request"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Access Denied"
        case .tooManyRequests:
            return "Rate Limit Exceeded"
        case .internalServerError:
            return "Server Error"
        case .noData:
            return "No Data"
        case .decodingError:
            return "Data Error"
        case .networkFailure:
            return "Network Error"
        case .unknown:
            return "Error"
        }
    }
    
    var message: String {
        switch self {
        case .badRequest(let customMessage):
            return customMessage ?? "Invalid value provided. Please check your request."
        case .unauthorized:
            return "API key is missing or invalid. Please check your configuration."
        case .forbidden:
            return "Your API Key subscription plan doesn't support this endpoint. Please upgrade your plan."
        case .tooManyRequests:
            return "You've exceeded your API Key's HTTP request rate limit. Rate limits reset every minute. Please wait a moment."
        case .internalServerError:
            return "An internal server error occurred. Please try again later."
        case .noData:
            return "No data was received from the server."
        case .decodingError:
            return "Failed to process the data received from the server."
        case .networkFailure(let error):
            return "Network connection failed: \(error.localizedDescription)"
        case .unknown:
            return "An unexpected error occurred. Please try again."
        }
    }
    
    var actionButtonTitle: String {
        switch self {
        case .tooManyRequests:
            return "Wait & Retry"
        case .unauthorized, .forbidden:
            return "OK"
        default:
            return "Retry"
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
            return .badRequest(message: "Invalid URL configuration")
        case .noData:
            return .noData
        case .decodingError:
            return .decodingError
        case .serverError(let statusCode):
            switch statusCode {
            case 400:
                return .badRequest(message: "Invalid value for \"id\"")
            case 401:
                return .unauthorized
            case 403:
                return .forbidden
            case 429:
                return .tooManyRequests
            case 500...599:
                return .internalServerError
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
