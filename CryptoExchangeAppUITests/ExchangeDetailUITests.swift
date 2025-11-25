import XCTest

final class ExchangeDetailUITests: XCTestCase {
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
        
        // Navigate to detail
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 10))
        
        let firstCell = tableView.cells.firstMatch
        if firstCell.waitForExistence(timeout: 5) {
            firstCell.tap()
        }
        
        // Aguardar a tela de detalhe carregar
        let detailNavigationBar = app.navigationBars["Details"]
        XCTAssertTrue(detailNavigationBar.waitForExistence(timeout: 5))
        
        // Aguardar conteúdo carregar (loading indicator desaparecer)
        Thread.sleep(forTimeInterval: 1)
    }
    
    override func tearDownWithError() throws {
        app?.terminate()
        app = nil
    }
    
    func testDetailDisplaysLogo() throws {
        // Given - scroll view deve existir primeiro
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "Detail should have scroll view")
        
        // When/Then - logo está dentro do scroll view
        let logoImage = scrollView.images.firstMatch
        XCTAssertTrue(logoImage.exists, "Detail should display logo")
    }
    
    func testDetailDisplaysName() throws {
        // Given
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "Detail should have scroll view")
        
        // Then - nome "Binance" deve estar visível
        let nameLabel = scrollView.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'Binance'")).firstMatch
        XCTAssertTrue(nameLabel.exists, "Detail should display name")
    }
    
    func testDetailDisplaysID() throws {
        // Given
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // Then
        let idLabel = scrollView.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'ID:'")).firstMatch
        XCTAssertTrue(idLabel.exists, "Detail should display ID")
    }
    
    func testDetailDisplaysDescription() throws {
        // Given
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // Then - buscar por parte da descrição mockada
        let descriptionText = scrollView.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'cryptocurrency exchange'")).firstMatch
        XCTAssertTrue(descriptionText.exists, "Detail should display description")
    }
    
    func testDetailDisplaysWebsite() throws {
        // Given
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // Then - verificar label "Website" e valor
        let websiteLabel = scrollView.staticTexts["Website"]
        XCTAssertTrue(websiteLabel.exists, "Detail should display website label")
        
        // Verificar se tem URL
        let websiteValue = scrollView.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'binance.com'")).firstMatch
        XCTAssertTrue(websiteValue.exists, "Detail should display website URL")
    }
    
    func testDetailDisplaysMakerFee() throws {
        // Given
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // Then
        let makerFeeLabel = scrollView.staticTexts["Maker Fee"]
        XCTAssertTrue(makerFeeLabel.exists, "Detail should display maker fee label")
        
        // Verificar valor (0.10% do mock)
        let makerFeeValue = scrollView.staticTexts.containing(NSPredicate(format: "label CONTAINS '0.10%'")).firstMatch
        XCTAssertTrue(makerFeeValue.exists, "Detail should display maker fee value")
    }
    
    func testDetailDisplaysTakerFee() throws {
        // Given
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // Then
        let takerFeeLabel = scrollView.staticTexts["Taker Fee"]
        XCTAssertTrue(takerFeeLabel.exists, "Detail should display taker fee label")
        
        // Verificar valor (0.10% do mock)
        let takerFeeValue = scrollView.staticTexts.containing(NSPredicate(format: "label CONTAINS '0.10%'")).firstMatch
        XCTAssertTrue(takerFeeValue.exists, "Detail should display taker fee value")
    }
    
    func testDetailDisplaysDateLaunched() throws {
        // Given
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // Then
        let dateLabel = scrollView.staticTexts["Date Launched"]
        XCTAssertTrue(dateLabel.exists, "Detail should display date launched label")
        
        // Verificar se tem data formatada
        let dateValue = scrollView.staticTexts.matching(NSPredicate(format: "label MATCHES '\\\\d{2}/\\\\d{2}/\\\\d{4}'")).firstMatch
        XCTAssertTrue(dateValue.exists, "Detail should display formatted date")
    }
    
    func testDetailDisplaysTradingPairs() throws {
        // Given
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // When - scroll para baixo para ver Trading Pairs
        scrollView.swipeUp()
        scrollView.swipeUp()
        
        // Aguardar animação
        Thread.sleep(forTimeInterval: 0.5)
        
        // Then
        let tradingPairsLabel = app.staticTexts["Trading Pairs"]
        XCTAssertTrue(tradingPairsLabel.exists, "Detail should display Trading Pairs section")
    }
    
    func testDetailHasCurrenciesTable() throws {
        // Given
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // When - scroll para baixo
        scrollView.swipeUp()
        scrollView.swipeUp()
        
        // Aguardar animação
        Thread.sleep(forTimeInterval: 0.5)
        
        // Then - verificar se existe tabela de moedas (USD deve estar presente)
        let currencyLabel = app.staticTexts["USD"]
        XCTAssertTrue(currencyLabel.exists, "Detail should display currencies")
    }
    
    func testDetailScrollsToBottom() throws {
        // Given
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // When - scroll múltiplas vezes
        for _ in 0..<3 {
            scrollView.swipeUp()
            Thread.sleep(forTimeInterval: 0.3)
        }
        
        // Then - verificar que ainda está na tela de detalhe
        let detailNavigationBar = app.navigationBars["Details"]
        XCTAssertTrue(detailNavigationBar.exists, "Should still be on detail screen")
    }
    
    func testDetailDisplaysAllInfoInOrder() throws {
        // Test completo verificando todos os elementos em sequência
        
        // 1. Logo
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        let logoImage = scrollView.images.firstMatch
        XCTAssertTrue(logoImage.exists, "Should display logo")
        
        // 2. Name
        let nameLabel = scrollView.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'Binance'")).firstMatch
        XCTAssertTrue(nameLabel.exists, "Should display name")
        
        // 3. ID
        let idLabel = scrollView.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'ID:'")).firstMatch
        XCTAssertTrue(idLabel.exists, "Should display ID")
        
        // 4. Description
        let descriptionText = scrollView.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'cryptocurrency'")).firstMatch
        XCTAssertTrue(descriptionText.exists, "Should display description")
        
        // 5. Info card (website, fees, date)
        XCTAssertTrue(scrollView.staticTexts["Website"].exists, "Should display website")
        XCTAssertTrue(scrollView.staticTexts["Maker Fee"].exists, "Should display maker fee")
        XCTAssertTrue(scrollView.staticTexts["Taker Fee"].exists, "Should display taker fee")
        XCTAssertTrue(scrollView.staticTexts["Date Launched"].exists, "Should display date")
        
        // 6. Trading Pairs
        scrollView.swipeUp()
        scrollView.swipeUp()
        Thread.sleep(forTimeInterval: 0.5)
        
        let tradingPairsLabel = app.staticTexts["Trading Pairs"]
        XCTAssertTrue(tradingPairsLabel.exists, "Should display Trading Pairs")
        
        // 7. Currency (USD)
        let usdLabel = app.staticTexts["USD"]
        XCTAssertTrue(usdLabel.exists, "Should display USD currency")
    }
    
    func testNavigateBackToList() throws {
        // Given
        let detailNavigationBar = app.navigationBars["Details"]
        XCTAssertTrue(detailNavigationBar.exists)
        
        // When - tap no botão de voltar
        let backButton = detailNavigationBar.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists, "Should have back button")
        backButton.tap()
        
        // Then - deve voltar para a lista
        let listNavigationBar = app.navigationBars["Cryptocurrencies"]
        XCTAssertTrue(listNavigationBar.waitForExistence(timeout: 3), "Should navigate back to list")
        
        // Verificar que a tabela existe
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists, "Should display list table")
    }
}
