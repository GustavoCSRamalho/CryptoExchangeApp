import XCTest
@testable import CryptoExchangeApp

final class ErrorMessagesTests: XCTestCase {
    
    func testBadRequestError() {
        // Given
        let error = APIError.badRequest(message: "Invalid ID")
        
        // Then
        XCTAssertEqual(error.title, "Invalid Request")
        XCTAssertEqual(error.message, "Invalid ID")
        XCTAssertTrue(error.shouldShowRetry)
    }
    
    func testUnauthorizedError() {
        // Given
        let error = APIError.unauthorized
        
        // Then
        XCTAssertEqual(error.title, "Unauthorized")
        XCTAssertTrue(error.message.contains("API key"))
        XCTAssertFalse(error.shouldShowRetry)
    }
    
    func testForbiddenError() {
        // Given
        let error = APIError.forbidden
        
        // Then
        XCTAssertEqual(error.title, "Access Denied")
        XCTAssertTrue(error.message.contains("subscription plan"))
        XCTAssertFalse(error.shouldShowRetry)
    }
    
    func testTooManyRequestsError() {
        // Given
        let error = APIError.tooManyRequests
        
        // Then
        XCTAssertEqual(error.title, "Rate Limit Exceeded")
        XCTAssertTrue(error.message.contains("rate limit"))
        XCTAssertEqual(error.actionButtonTitle, "Wait & Retry")
        XCTAssertTrue(error.shouldShowRetry)
    }
    
    func testInternalServerError() {
        // Given
        let error = APIError.internalServerError
        
        // Then
        XCTAssertEqual(error.title, "Server Error")
        XCTAssertTrue(error.message.contains("internal server error"))
        XCTAssertTrue(error.shouldShowRetry)
    }
    
    func testNetworkErrorToAPIError() {
        // Given
        let networkError400 = NetworkError.serverError(statusCode: 400)
        let networkError401 = NetworkError.serverError(statusCode: 401)
        let networkError403 = NetworkError.serverError(statusCode: 403)
        let networkError429 = NetworkError.serverError(statusCode: 429)
        let networkError500 = NetworkError.serverError(statusCode: 500)
        
        // When
        let apiError400 = networkError400.toAPIError()
        let apiError401 = networkError401.toAPIError()
        let apiError403 = networkError403.toAPIError()
        let apiError429 = networkError429.toAPIError()
        let apiError500 = networkError500.toAPIError()
        
        // Then
        XCTAssertEqual(apiError400.title, "Invalid Request")
        XCTAssertEqual(apiError401.title, "Unauthorized")
        XCTAssertEqual(apiError403.title, "Access Denied")
        XCTAssertEqual(apiError429.title, "Rate Limit Exceeded")
        XCTAssertEqual(apiError500.title, "Server Error")
    }
}
