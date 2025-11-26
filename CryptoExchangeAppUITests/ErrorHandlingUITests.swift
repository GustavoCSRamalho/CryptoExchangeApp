import XCTest

final class ErrorHandlingUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testUnauthorizedError() throws {
        // Given
        app = XCUIApplication()
        app.launchArguments = [
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_US"
        ]
        app.launchEnvironment = [
            "UI_TESTING": "1",
            "MOCK_ERROR": "1",
            "MOCK_ERROR_TYPE": "401"
        ]
        app.launch()
        
        // Wait for error view
        Thread.sleep(forTimeInterval: 1)
        
        // Then
        let errorTitle = app.staticTexts["Unauthorized"]
        XCTAssertTrue(errorTitle.waitForExistence(timeout: 5), "Should display unauthorized error")
        
        let errorMessage = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'API key'")).firstMatch
        XCTAssertTrue(errorMessage.exists, "Should display API key error message")
    }
    
    func testForbiddenError() throws {
        // Given
        app = XCUIApplication()
        app.launchArguments = [
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_US"
        ]
        app.launchEnvironment = [
            "UI_TESTING": "1",
            "MOCK_ERROR": "1",
            "MOCK_ERROR_TYPE": "403"
        ]
        app.launch()
        
        // Wait for error view
        Thread.sleep(forTimeInterval: 1)
        
        // Then
        let errorTitle = app.staticTexts["Access Denied"]
        XCTAssertTrue(errorTitle.waitForExistence(timeout: 5), "Should display forbidden error")
        
        let errorMessage = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'subscription plan'")).firstMatch
        XCTAssertTrue(errorMessage.exists, "Should display subscription error message")
    }
    
    func testRateLimitError() throws {
        // Given
        app = XCUIApplication()
        app.launchArguments = [
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_US"
        ]
        app.launchEnvironment = [
            "UI_TESTING": "1",
            "MOCK_ERROR": "1",
            "MOCK_ERROR_TYPE": "429"
        ]
        app.launch()
        
        // Wait for error view
        Thread.sleep(forTimeInterval: 1)
        
        // Then
        let errorTitle = app.staticTexts["Rate Limit Exceeded"]
        XCTAssertTrue(errorTitle.waitForExistence(timeout: 5), "Should display rate limit error")
        
        let retryButton = app.buttons["Wait & Retry"]
        XCTAssertTrue(retryButton.exists, "Should display Wait & Retry button")
        
        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Should display Cancel button")
    }
    
    func testServerError() throws {
        // Given
        app = XCUIApplication()
        app.launchArguments = [
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_US"
        ]
        app.launchEnvironment = [
            "UI_TESTING": "1",
            "MOCK_ERROR": "1",
            "MOCK_ERROR_TYPE": "500"
        ]
        app.launch()
        
        Thread.sleep(forTimeInterval: 1)
        
        // Then
        let errorTitle = app.staticTexts["Server Error"]
        XCTAssertTrue(errorTitle.waitForExistence(timeout: 5), "Should display server error")
        
        let errorMessage = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS[c] 'Server error' OR label CONTAINS '500'")
        ).firstMatch
        XCTAssertTrue(errorMessage.exists, "Should display server error message")
        
        let retryButton = app.buttons["Retry"]
        XCTAssertTrue(retryButton.exists, "Should display Retry button")
    }
    
    func testBadRequestError() throws {
        // Given
        app = XCUIApplication()
        app.launchArguments = [
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_US"
        ]
        app.launchEnvironment = [
            "UI_TESTING": "1",
            "MOCK_ERROR": "1",
            "MOCK_ERROR_TYPE": "400"
        ]
        app.launch()
        

        Thread.sleep(forTimeInterval: 1)
        
        // Then
        let errorTitle = app.staticTexts["Invalid Request"]
        XCTAssertTrue(errorTitle.waitForExistence(timeout: 5), "Should display bad request error")
        
        let retryButton = app.buttons["Retry"]
        XCTAssertTrue(retryButton.exists, "Should display Retry button")
        
        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Should display Cancel button")
    }
    
    func testErrorIconDisplay() throws {
        // Given
        app = XCUIApplication()
        app.launchArguments = [
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_US"
        ]
        app.launchEnvironment = [
            "UI_TESTING": "1",
            "MOCK_ERROR": "1",
            "MOCK_ERROR_TYPE": "500"
        ]
        app.launch()
        
        // Wait for error view
        Thread.sleep(forTimeInterval: 1)
        
        // Then
        let errorIcon = app.images.firstMatch
        XCTAssertTrue(errorIcon.exists, "Should display error icon")
    }
}
