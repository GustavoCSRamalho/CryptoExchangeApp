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
        
        let binanceCell = tableView.cells
            .containing(NSPredicate(format: "label CONTAINS[c] 'Binance'"))
            .firstMatch
        
        XCTAssertTrue(binanceCell.waitForExistence(timeout: 5))
    }
    
    func testMockedDataDisplaysCoinbase() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let coinbaseCell = tableView.cells
            .containing(NSPredicate(format: "label CONTAINS[c] 'Coinbase'"))
            .firstMatch
        
        XCTAssertTrue(coinbaseCell.waitForExistence(timeout: 5))
    }
    
    func testMockedDataDisplaysKraken() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let krakenCell = tableView.cells
            .containing(NSPredicate(format: "label CONTAINS[c] 'Kraken'"))
            .firstMatch
        
        XCTAssertTrue(krakenCell.waitForExistence(timeout: 5))
    }
    
    func testCellDisplaysVolume() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        
        let volumeLabel = firstCell.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'Volume'"))
            .firstMatch
        
        XCTAssertTrue(volumeLabel.waitForExistence(timeout: 5))
    }
    
    func testCellDisplaysDateLaunched() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        
        let dateLabel = firstCell.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'Launched'"))
            .firstMatch
        
        XCTAssertTrue(dateLabel.waitForExistence(timeout: 5))
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
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        let detailNavigationBar = app.navigationBars["Details"]
        XCTAssertTrue(detailNavigationBar.waitForExistence(timeout: 5))
    }
    
    func testBackNavigationFromDetail() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        let detailNavigationBar = app.navigationBars["Details"]
        XCTAssertTrue(detailNavigationBar.waitForExistence(timeout: 5))
        
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()
        
        let listNavigationBar = app.navigationBars["Exchanges"]
        XCTAssertTrue(listNavigationBar.waitForExistence(timeout: 5))
    }
    
    // MARK: - Detail Tests
    func testDetailScreenElements() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        let detailNavigationBar = app.navigationBars["Details"]
        XCTAssertTrue(detailNavigationBar.waitForExistence(timeout: 5))
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
    }
    
    func testDetailDisplaysID() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        let idLabel = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'ID:'"))
            .firstMatch
        
        XCTAssertTrue(idLabel.waitForExistence(timeout: 5))
    }
    
    func testDetailDisplaysDescription() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        let descriptionText = app.staticTexts
            .containing(NSPredicate(format: "label CONTAINS[c] 'cryptocurrency exchange'"))
            .firstMatch
        
        XCTAssertTrue(descriptionText.waitForExistence(timeout: 5))
    }
    
    func testDetailDisplaysWebsite() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        let websiteLabel = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'Website'"))
            .firstMatch
        
        XCTAssertTrue(websiteLabel.waitForExistence(timeout: 5))
    }
    
    func testDetailDisplaysMakerFee() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        let makerFeeLabel = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'Maker Fee'"))
            .firstMatch
        
        XCTAssertTrue(makerFeeLabel.waitForExistence(timeout: 5))
    }
    
    func testDetailDisplaysTakerFee() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        let takerFeeLabel = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'Taker Fee'"))
            .firstMatch
        
        XCTAssertTrue(takerFeeLabel.waitForExistence(timeout: 5))
    }
    
    func testDetailDisplaysDateLaunched() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        let dateLabel = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'Date Launched'"))
            .firstMatch
        
        XCTAssertTrue(dateLabel.waitForExistence(timeout: 5))
    }
    
    func testDetailDisplaysCurrencies() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
        
        scrollView.swipeUp()
        
        let currenciesLabel = app.staticTexts
            .matching(NSPredicate(format: "label CONTAINS[c] 'Currencies' OR label CONTAINS[c] 'Assets'"))
            .firstMatch
        
        XCTAssertTrue(currenciesLabel.waitForExistence(timeout: 5))
    }
    
    func testDetailScrolling() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5))
        
        let firstCell = tableView.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
        
        scrollView.swipeUp()
        scrollView.swipeUp()
        
        XCTAssertTrue(scrollView.exists)
    }
}
