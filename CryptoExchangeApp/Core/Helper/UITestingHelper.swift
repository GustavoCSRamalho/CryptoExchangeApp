import Foundation

enum UITestingHelper {
    static var isUITesting: Bool {
        return ProcessInfo.processInfo.environment["UI_TESTING"] == "1"
    }
    
    static var shouldMockNetworkSuccess: Bool {
        return ProcessInfo.processInfo.environment["MOCK_SUCCESS"] == "1"
    }
    
    static var shouldMockNetworkError: Bool {
        return ProcessInfo.processInfo.environment["MOCK_ERROR"] == "1"
    }
    
    static var mockErrorType: String? {
        return ProcessInfo.processInfo.environment["MOCK_ERROR_TYPE"]
    }
}
