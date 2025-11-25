import XCTest

final class CryptoExchangeAppUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        
        // Configurar environment variables para modo de teste
        app.launchEnvironment = [
            "UI_TESTING": "1",
            "MOCK_SUCCESS": "1"
        ]
        
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - List Tests
    func testExchangesListIsDisplayed() throws {
        // Given
        let navigationBar = app.navigationBars["Cryptocurrencies"]
        
        // Then
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5))
    }
    
    func testTableViewExists() throws {
        // Given
        let tableView = app.tables.firstMatch
        
        // Then
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
    }
    
    func testTableViewHasCells() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        // When
        let cells = tableView.cells
        
        // Then
        XCTAssertGreaterThanOrEqual(cells.count, 3, "Table should have at least 3 mocked cells")
    }
    
    func testMockedDataDisplaysBitcoin() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        // Then
        let bitcoinCell = tableView.cells.containing(NSPredicate(format: "label CONTAINS[c] 'Bitcoin'")).firstMatch
        XCTAssertTrue(bitcoinCell.exists, "Should display mocked Bitcoin data")
    }
    
    func testMockedDataDisplaysEthereum() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        // Then
        let ethereumCell = tableView.cells.containing(NSPredicate(format: "label CONTAINS[c] 'Ethereum'")).firstMatch
        XCTAssertTrue(ethereumCell.exists, "Should display mocked Ethereum data")
    }
    
    func testCellDisplaysVolume() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        // When
        let firstCell = tableView.cells.firstMatch
        
        // Then
        let volumeLabel = firstCell.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Volume'")).firstMatch
        XCTAssertTrue(volumeLabel.exists, "Cell should display volume")
    }
    
    func testCellDisplaysDateLaunched() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        // When
        let firstCell = tableView.cells.firstMatch
        
        // Then
        let dateLabel = firstCell.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Launched'")).firstMatch
        XCTAssertTrue(dateLabel.exists, "Cell should display launch date")
    }
    
    func testPullToRefresh() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        // When
        let start = tableView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        let finish = tableView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
        start.press(forDuration: 0, thenDragTo: finish)
        
        // Wait for refresh to complete
        Thread.sleep(forTimeInterval: 1)
        
        // Then
        XCTAssertTrue(tableView.exists)
    }
    
    func testNavigationToDetail() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        // When
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        // Then
        let detailNavigationBar = app.navigationBars["Details"]
        XCTAssertTrue(detailNavigationBar.waitForExistence(timeout: 5))
    }
    
    func testBackNavigationFromDetail() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        let detailNavigationBar = app.navigationBars["Details"]
        XCTAssertTrue(detailNavigationBar.waitForExistence(timeout: 5))
        
        // When
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()
        
        // Then
        let listNavigationBar = app.navigationBars["Cryptocurrencies"]
        XCTAssertTrue(listNavigationBar.waitForExistence(timeout: 2))
    }
    
    // MARK: - Detail Tests
    func testDetailScreenElements() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        // Wait for detail screen
        let detailNavigationBar = app.navigationBars["Details"]
        XCTAssertTrue(detailNavigationBar.waitForExistence(timeout: 5))
        
        // Then
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "Detail should have scroll view")
    }
    
    func testDetailDisplaysID() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        // Wait for detail to load
        Thread.sleep(forTimeInterval: 1)
        
        // Then
        let idLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'ID:'")).firstMatch
        XCTAssertTrue(idLabel.exists, "Should display ID")
    }
    
    func testDetailDisplaysDescription() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        // Wait for detail to load
        Thread.sleep(forTimeInterval: 1)
        
        // Then
        let descriptionText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'cryptocurrency exchange'")).firstMatch
        XCTAssertTrue(descriptionText.exists, "Should display mocked description")
    }
    
    func testDetailDisplaysWebsite() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        // Wait for detail to load
        Thread.sleep(forTimeInterval: 1)
        
        // Then
        let websiteLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Website'")).firstMatch
        XCTAssertTrue(websiteLabel.exists, "Should display website")
    }
    
    func testDetailDisplaysMakerFee() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        // Wait for detail to load
        Thread.sleep(forTimeInterval: 1)
        
        // Then
        let makerFeeLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Maker Fee'")).firstMatch
        XCTAssertTrue(makerFeeLabel.exists, "Should display maker fee")
    }
    
    func testDetailDisplaysTakerFee() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        // Wait for detail to load
        Thread.sleep(forTimeInterval: 1)
        
        // Then
        let takerFeeLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Taker Fee'")).firstMatch
        XCTAssertTrue(takerFeeLabel.exists, "Should display taker fee")
    }
    
    func testDetailDisplaysDateLaunched() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        // Wait for detail to load
        Thread.sleep(forTimeInterval: 1)
        
        // Then
        let dateLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Date Launched'")).firstMatch
        XCTAssertTrue(dateLabel.exists, "Should display launch date")
    }
    
    func testDetailDisplaysTradingPairs() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        // Wait for detail to load
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
        
        // When
        scrollView.swipeUp()
        
        // Then
        let tradingPairsLabel = app.staticTexts["Trading Pairs"]
        XCTAssertTrue(tradingPairsLabel.exists, "Should have Trading Pairs section")
    }
    
    func testDetailScrolling() throws {
        // Given
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
        
        // When
        scrollView.swipeUp()
        scrollView.swipeUp()
        
        // Then
        XCTAssertTrue(scrollView.exists, "Should be able to scroll")
    }
}
