import XCTest
@testable import CryptoExchangeApp

final class ExchangesPresenterTests: XCTestCase {
    var sut: ExchangesPresenter!
    var viewControllerSpy: ExchangesViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        sut = ExchangesPresenter()
        viewControllerSpy = ExchangesViewControllerSpy()
        sut.viewController = viewControllerSpy
    }
    
    override func tearDown() {
        sut = nil
        viewControllerSpy = nil
        super.tearDown()
    }
    
    func testPresentExchanges() {
        // Given
        let cryptocurrency = makeCryptocurrency()
        let response = Exchanges.FetchExchanges.Response(cryptocurrencies: [cryptocurrency])
        
        // When
        sut.presentExchanges(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayExchangesCalled)
        XCTAssertEqual(viewControllerSpy.displayedCryptocurrencies?.count, 1)
        XCTAssertEqual(viewControllerSpy.displayedCryptocurrencies?.first?.name, "Bitcoin")
        XCTAssertEqual(viewControllerSpy.displayedCryptocurrencies?.first?.symbol, "BTC")
    }
    
    func testPresentError() {
        // Given
        let response = Exchanges.Error.Response(message: "Network error")
        
        // When
        sut.presentError(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayErrorCalled)
        XCTAssertEqual(viewControllerSpy.displayedErrorMessage, "Network error")
    }
    
    func testPresentExchangesWithVolume() {
        // Given
        let cryptocurrency = makeCryptocurrencyWithQuote()
        let response = Exchanges.FetchExchanges.Response(cryptocurrencies: [cryptocurrency])
        
        // When
        sut.presentExchanges(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayExchangesCalled)
        XCTAssertEqual(viewControllerSpy.displayedCryptocurrencies?.first?.spotVolume, "$1.50B")
    }
    
    // MARK: - Helpers
    private func makeCryptocurrency() -> Cryptocurrency {
        return Cryptocurrency(
            id: 1,
            name: "Bitcoin",
            symbol: "BTC",
            slug: "bitcoin",
            cmcRank: 1,
            numMarketPairs: 500,
            circulatingSupply: 19000000,
            totalSupply: 19000000,
            maxSupply: 21000000,
            infiniteSupply: false,
            lastUpdated: "2024-01-01T00:00:00.000Z",
            dateAdded: "2013-04-28T00:00:00.000Z",
            tags: ["mineable"],
            platform: nil,
            quote: nil
        )
    }
    
    private func makeCryptocurrencyWithQuote() -> Cryptocurrency {
        let quoteData = QuoteData(
            price: 50000,
            volume24h: 1500000000,
            volumeChange24h: 5.2,
            percentChange1h: 0.5,
            percentChange24h: 2.3,
            percentChange7d: 10.5,
            marketCap: 950000000000,
            marketCapDominance: 45.0,
            fullyDilutedMarketCap: 1050000000000,
            lastUpdated: "2023-01-01T00:00:00.000Z"
        )
        
        // Criar Quote manualmente usando o inicializador
        let quoteDictionary: [String: QuoteData] = ["USD": quoteData]
        let jsonData = try! JSONEncoder().encode(quoteDictionary)
        let quote = try! JSONDecoder().decode(Quote.self, from: jsonData)
        
        return Cryptocurrency(
            id: 1,
            name: "Bitcoin",
            symbol: "BTC",
            slug: "bitcoin",
            cmcRank: 1,
            numMarketPairs: 500,
            circulatingSupply: 19000000,
            totalSupply: 19000000,
            maxSupply: 21000000,
            infiniteSupply: false,
            lastUpdated: "2024-01-01T00:00:00.000Z",
            dateAdded: "2013-04-28T00:00:00.000Z",
            tags: ["mineable"],
            platform: nil,
            quote: quote
        )
    }
}

class ExchangesViewControllerSpy: ExchangesDisplayLogic {
    var displayExchangesCalled = false
    var displayErrorCalled = false
    var displayedCryptocurrencies: [CryptocurrencyViewModel]?
    var displayedErrorMessage: String?
    
    func displayExchanges(viewModel: Exchanges.FetchExchanges.ViewModel) {
        displayExchangesCalled = true
        displayedCryptocurrencies = viewModel.cryptocurrencies
    }
    
    func displayError(viewModel: Exchanges.Error.ViewModel) {
        displayErrorCalled = true
        displayedErrorMessage = viewModel.message
    }
}
