import XCTest

final class ExchangeAppUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        
        app.launchArguments = [
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_US"
        ]
        
        app.launchEnvironment = ["UI_TESTING": "1", "MOCK_SUCCESS": "1"]
        
        
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - List Tests
    func testExchangesListIsDisplayed() throws {
        let navigationBar = app.navigationBars["Exchanges"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5))
    }
    
    func testTableViewExists() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
    }
    
    func testTableViewHasCells() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let cells = tableView.cells
        XCTAssertGreaterThanOrEqual(cells.count, 3, "Table should have at least 3 mocked cells")
    }
    
    func testMockedDataDisplaysBinance() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let binanceCell = tableView.cells.containing(NSPredicate(format: "label CONTAINS[c] 'Binance'")).firstMatch
        XCTAssertTrue(binanceCell.exists, "Should display mocked Binance data")
    }
    
    func testMockedDataDisplaysCoinbase() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let coinbaseCell = tableView.cells.containing(NSPredicate(format: "label CONTAINS[c] 'Coinbase'")).firstMatch
        XCTAssertTrue(coinbaseCell.exists, "Should display mocked Coinbase data")
    }
    
    func testMockedDataDisplaysKraken() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let krakenCell = tableView.cells.containing(NSPredicate(format: "label CONTAINS[c] 'Kraken'")).firstMatch
        XCTAssertTrue(krakenCell.exists, "Should display mocked Kraken data")
    }
    
    func testCellDisplaysVolume() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        
        let volumeLabel = firstCell.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Volume'")).firstMatch
        XCTAssertTrue(volumeLabel.exists, "Cell should display volume")
    }
    
    func testCellDisplaysDateLaunched() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        
        let dateLabel = firstCell.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Launched'")).firstMatch
        XCTAssertTrue(dateLabel.exists, "Cell should display launch date")
    }
    
    func testPullToRefresh() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let start = tableView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        let finish = tableView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
        start.press(forDuration: 0, thenDragTo: finish)
        
        Thread.sleep(forTimeInterval: 1)
        
        XCTAssertTrue(tableView.exists)
    }
    
    func testNavigationToDetail() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        let detailNavigationBar = app.navigationBars["Details"]
        XCTAssertTrue(detailNavigationBar.waitForExistence(timeout: 5))
    }
    
    func testBackNavigationFromDetail() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        let detailNavigationBar = app.navigationBars["Details"]
        XCTAssertTrue(detailNavigationBar.waitForExistence(timeout: 5))
        
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()
        
        let listNavigationBar = app.navigationBars["Exchanges"]
        XCTAssertTrue(listNavigationBar.waitForExistence(timeout: 2))
    }
    
    // MARK: - Detail Tests
    func testDetailScreenElements() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        let detailNavigationBar = app.navigationBars["Details"]
        XCTAssertTrue(detailNavigationBar.waitForExistence(timeout: 5))
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "Detail should have scroll view")
    }
    
    func testDetailDisplaysID() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        let idLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'ID:'")).firstMatch
        XCTAssertTrue(idLabel.exists, "Should display ID")
    }
    
    func testDetailDisplaysDescription() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        let descriptionText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'cryptocurrency exchange'")).firstMatch
        XCTAssertTrue(descriptionText.exists, "Should display mocked description")
    }
    
    func testDetailDisplaysWebsite() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        let websiteLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Website'")).firstMatch
        XCTAssertTrue(websiteLabel.exists, "Should display website")
    }
    
    func testDetailDisplaysMakerFee() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        let makerFeeLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Maker Fee'")).firstMatch
        XCTAssertTrue(makerFeeLabel.exists, "Should display maker fee")
    }
    
    func testDetailDisplaysTakerFee() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        let takerFeeLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Taker Fee'")).firstMatch
        XCTAssertTrue(takerFeeLabel.exists, "Should display taker fee")
    }
    
    func testDetailDisplaysDateLaunched() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        let dateLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Date Launched'")).firstMatch
        XCTAssertTrue(dateLabel.exists, "Should display launch date")
    }
    
    func testDetailDisplaysCurrencies() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
        
        scrollView.swipeUp()
        
        let currenciesLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Currencies' OR label CONTAINS[c] 'Assets'")).firstMatch
        XCTAssertTrue(currenciesLabel.exists, "Should have Currencies section")
    }
    
    func testDetailScrolling() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2))
        firstCell.tap()
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
        
        scrollView.swipeUp()
        scrollView.swipeUp()
        
        XCTAssertTrue(scrollView.exists, "Should be able to scroll")
    }
}
