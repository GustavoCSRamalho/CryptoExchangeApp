import XCTest

final class ExchangeDetailUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        
        // Forçar inglês para testes consistentes
        app.launchArguments = [
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_US"
        ]
        
        app.launchEnvironment = ["UI_TESTING": "1", "MOCK_SUCCESS": "1"]
        
        app.launch()
        
        // Aguardar e navegar para detalhes
        let tableView = app.tables.firstMatch
        guard tableView.waitForExistence(timeout: 10) else {
            XCTFail("Table view não apareceu")
            return
        }
        
        let firstCell = tableView.cells.firstMatch
        guard firstCell.waitForExistence(timeout: 5) else {
            XCTFail("Primeira célula não apareceu")
            return
        }
        
        firstCell.tap()
        
        // Aguardar tela de detalhes carregar
        let navigationBar = app.navigationBars.firstMatch
        guard navigationBar.waitForExistence(timeout: 5) else {
            XCTFail("Navigation bar não apareceu")
            return
        }
        
        // Aguardar loading indicator desaparecer
        let loadingIndicator = app.activityIndicators.firstMatch
        if loadingIndicator.exists {
            // Aguardar até 3 segundos para o loading desaparecer
            let expectation = XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "exists == false"),
                object: loadingIndicator
            )
            let result = XCTWaiter.wait(for: [expectation], timeout: 3.0)
            if result != .completed {
                print("Warning: Loading indicator ainda visível")
            }
        }
        
        // Aguardar adicional para garantir que a UI está estável
        Thread.sleep(forTimeInterval: 0.5)
    }
    
    override func tearDownWithError() throws {
        app?.terminate()
        app = nil
    }
    
    // MARK: - Basic Display Tests
    
    func testDetailScreenLoads() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "ScrollView should exist")
    }
    
    func testDetailDisplaysLogo() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "ScrollView should exist")
        
        // Logo está dentro do scrollView
        let images = scrollView.images
        XCTAssertTrue(images.count > 0, "Should have at least one image (logo)")
    }
    
    func testDetailDisplaysName() throws {
        // Binance está no nameLabel
        let nameLabel = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'Binance'")).firstMatch
        XCTAssertTrue(nameLabel.exists, "Should display Binance name")
    }
    
    func testDetailDisplaysID() throws {
        // ID está formatado como "ID: 270"
        let idLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'ID:' OR label CONTAINS '270'")).firstMatch
        XCTAssertTrue(idLabel.exists, "Should display ID")
    }
    
    func testDetailDisplaysDescription() throws {
        // Descrição mockada contém "cryptocurrency exchange"
        let descriptionLabel = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'cryptocurrency exchange'")).firstMatch
        XCTAssertTrue(descriptionLabel.exists, "Should display description")
    }
    
    // MARK: - Info Card Tests
    
    func testDetailDisplaysWebsite() throws {
        // Website está no infoStackView
        let websiteLabel = app.staticTexts["Website"]
        XCTAssertTrue(websiteLabel.exists, "Should display Website label")
        
        // Valor do website (binance.com)
        let websiteValue = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'binance.com'")).firstMatch
        XCTAssertTrue(websiteValue.exists, "Should display website URL")
    }
    
    func testDetailDisplaysMakerFee() throws {
        let makerFeeLabel = app.staticTexts["Maker Fee"]
        XCTAssertTrue(makerFeeLabel.exists, "Should display Maker Fee label")
        
        // Mock retorna 0.10%
        let feeValue = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '0.10%'")).firstMatch
        XCTAssertTrue(feeValue.exists, "Should display maker fee value")
    }
    
    func testDetailDisplaysTakerFee() throws {
        let takerFeeLabel = app.staticTexts["Taker Fee"]
        XCTAssertTrue(takerFeeLabel.exists, "Should display Taker Fee label")
        
        // Mock retorna 0.10%
        let feeValue = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '0.10%'")).firstMatch
        XCTAssertTrue(feeValue.exists, "Should display taker fee value")
    }
    
    func testDetailDisplaysDateLaunched() throws {
        let dateLabel = app.staticTexts["Date Launched"]
        XCTAssertTrue(dateLabel.exists, "Should display Date Launched label")
    }
    
    // MARK: - Currencies Section Tests
    
    func testDetailDisplaysCurrenciesLabel() throws {
        let scrollView = app.scrollViews.firstMatch
        
        // Scroll para baixo até encontrar a seção de currencies
        for _ in 0..<3 {
            scrollView.swipeUp()
            Thread.sleep(forTimeInterval: 0.3)
        }
        
        // L10n.Detail.tradingPairs pode ser "Trading Pairs" ou "Currencies"
        let currenciesLabel = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS[c] 'Trading Pairs' OR label CONTAINS[c] 'Currencies' OR label CONTAINS[c] 'Assets'")
        ).firstMatch
        
        XCTAssertTrue(currenciesLabel.exists, "Should display currencies section label")
    }
    
    func testDetailDisplaysOriginProtocol() throws {
        let scrollView = app.scrollViews.firstMatch
        
        // Scroll até o final
        for _ in 0..<4 {
            scrollView.swipeUp()
            Thread.sleep(forTimeInterval: 0.3)
        }
        
        // Mock tem Origin Protocol (OGN)
        let ognLabel = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'Origin Protocol' OR label CONTAINS 'OGN'")
        ).firstMatch
        
        XCTAssertTrue(ognLabel.exists, "Should display Origin Protocol")
    }
    
    func testDetailDisplaysSmoothLovePotion() throws {
        let scrollView = app.scrollViews.firstMatch
        
        // Scroll até o final
        for _ in 0..<4 {
            scrollView.swipeUp()
            Thread.sleep(forTimeInterval: 0.3)
        }
        
        // Mock tem Smooth Love Potion (SLP)
        let slpLabel = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'Smooth Love Potion' OR label CONTAINS 'SLP'")
        ).firstMatch
        
        XCTAssertTrue(slpLabel.exists, "Should display Smooth Love Potion")
    }
    
    func testDetailDisplaysIDEX() throws {
        let scrollView = app.scrollViews.firstMatch
        
        // Scroll até o final
        for _ in 0..<4 {
            scrollView.swipeUp()
            Thread.sleep(forTimeInterval: 0.3)
        }
        
        // Mock tem IDEX
        let idexLabel = app.staticTexts["IDEX"]
        XCTAssertTrue(idexLabel.exists, "Should display IDEX")
    }
    
    func testDetailDisplaysCurrencyPrices() throws {
        let scrollView = app.scrollViews.firstMatch
        
        // Scroll até o final
        for _ in 0..<4 {
            scrollView.swipeUp()
            Thread.sleep(forTimeInterval: 0.3)
        }
        
        // Preços devem conter "$"
        let priceLabels = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '$'"))
        XCTAssertGreaterThan(priceLabels.count, 0, "Should display currency prices")
    }
    
    // MARK: - Scroll Tests
    
    func testDetailScrollsDown() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "ScrollView should exist")
        
        // Scroll para baixo
        scrollView.swipeUp()
        Thread.sleep(forTimeInterval: 0.3)
        
        // Ainda deve estar na tela de detalhes
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.exists, "Should still be on detail screen")
    }
    
    func testDetailScrollsToBottom() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // Scroll múltiplas vezes até o final
        for _ in 0..<5 {
            scrollView.swipeUp()
            Thread.sleep(forTimeInterval: 0.3)
        }
        
        // Ainda deve estar na tela de detalhes
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.exists, "Should still be on detail screen after scrolling to bottom")
    }
    
    func testDetailScrollsUp() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // Scroll para baixo primeiro
        for _ in 0..<3 {
            scrollView.swipeUp()
            Thread.sleep(forTimeInterval: 0.2)
        }
        
        // Scroll de volta para cima
        for _ in 0..<2 {
            scrollView.swipeDown()
            Thread.sleep(forTimeInterval: 0.2)
        }
        
        // Verificar que o nome ainda está visível (topo da tela)
        let nameLabel = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'Binance'")).firstMatch
        XCTAssertTrue(nameLabel.exists, "Should display name after scrolling back up")
    }
    
    // MARK: - Navigation Tests
    
    func testBackNavigation() throws {
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.exists, "Navigation bar should exist")
        
        // Botão de voltar
        let backButton = navigationBar.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists, "Back button should exist")
        
        backButton.tap()
        
        // Deve voltar para a lista
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 3), "Should navigate back to list")
        
        // Verificar que está na lista de exchanges
        let listNavigationBar = app.navigationBars.matching(NSPredicate(format: "identifier CONTAINS[c] 'Exchanges'")).firstMatch
        XCTAssertTrue(listNavigationBar.exists, "Should be back on exchanges list")
    }
    
    // MARK: - Complete Flow Test
    
    func testCompleteDetailFlow() throws {
        // 1. Verificar elementos básicos
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "ScrollView should exist")
        
        let nameLabel = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'Binance'")).firstMatch
        XCTAssertTrue(nameLabel.exists, "Should display name")
        
        let idLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'ID:'")).firstMatch
        XCTAssertTrue(idLabel.exists, "Should display ID")
        
        // 2. Verificar info card (sem scroll necessário)
        let websiteLabel = app.staticTexts["Website"]
        XCTAssertTrue(websiteLabel.exists, "Should display website")
        
        let makerFeeLabel = app.staticTexts["Maker Fee"]
        XCTAssertTrue(makerFeeLabel.exists, "Should display maker fee")
        
        // 3. Scroll e verificar currencies
        for _ in 0..<4 {
            scrollView.swipeUp()
            Thread.sleep(forTimeInterval: 0.3)
        }
        
        // Verificar pelo menos uma moeda mockada
        let hasAsset = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'Origin Protocol' OR label CONTAINS 'Smooth Love Potion' OR label CONTAINS 'IDEX'")
        ).firstMatch
        XCTAssertTrue(hasAsset.exists, "Should display at least one asset")
        
        // 4. Scroll de volta para o topo
        for _ in 0..<3 {
            scrollView.swipeDown()
            Thread.sleep(forTimeInterval: 0.2)
        }
        
        // 5. Verificar que nome ainda está visível
        XCTAssertTrue(nameLabel.exists, "Name should be visible after scrolling")
        
        // 6. Navegar de volta
        let backButton = app.navigationBars.firstMatch.buttons.element(boundBy: 0)
        backButton.tap()
        
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 3), "Should return to list")
    }
    
    // MARK: - Error State Tests (if needed)
    
    func testDetailWithoutMock() throws {
        // Este teste seria executado sem MOCK_SUCCESS para testar erro
        // Por enquanto, skip se estiver em modo mock
        let isMockEnabled = app.launchEnvironment["MOCK_SUCCESS"] == "1"
        if isMockEnabled {
            throw XCTSkip("Test requires non-mock mode")
        }
    }
}
