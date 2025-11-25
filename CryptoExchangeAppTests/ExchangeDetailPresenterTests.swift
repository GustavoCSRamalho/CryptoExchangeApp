import XCTest
@testable import CryptoExchangeApp

final class ExchangeDetailPresenterTests: XCTestCase {
    var sut: ExchangeDetailPresenter!
    var viewControllerSpy: ExchangeDetailViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        sut = ExchangeDetailPresenter()
        viewControllerSpy = ExchangeDetailViewControllerSpy()
        sut.viewController = viewControllerSpy
    }
    
    override func tearDown() {
        sut = nil
        viewControllerSpy = nil
        super.tearDown()
    }
    
    func testPresentDetail() {
        // Given
        let cryptocurrency = makeCryptocurrency()
        let exchange = makeExchange()
        let response = ExchangeDetail.FetchDetail.Response(exchange: exchange, cryptocurrency: cryptocurrency)
        
        // When
        sut.presentDetail(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayDetailCalled)
        XCTAssertEqual(viewControllerSpy.displayedViewModel?.name, "Binance")
        XCTAssertEqual(viewControllerSpy.displayedViewModel?.makerFee, "2.00%")
        XCTAssertEqual(viewControllerSpy.displayedViewModel?.takerFee, "4.00%")
    }
    
    func testPresentError() {
        // Given
        let response = ExchangeDetail.Error.Response(message: "Failed to load")
        
        // When
        sut.presentError(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayErrorCalled)
        XCTAssertEqual(viewControllerSpy.displayedErrorMessage, "Failed to load")
    }
    
    func testPresentDetailWithCurrencies() {
        // Given
        let cryptocurrency = makeCryptocurrencyWithQuote()
        let exchange = makeExchange()
        let response = ExchangeDetail.FetchDetail.Response(exchange: exchange, cryptocurrency: cryptocurrency)
        
        // When
        sut.presentDetail(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayDetailCalled)
        XCTAssertGreaterThan(viewControllerSpy.displayedViewModel?.currencies.count ?? 0, 0)
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
    
    private func makeExchange() -> Exchange {
        return Exchange(
            id: 270,
            name: "Binance",
            slug: "binance",
            logo: "https://example.com/logo.png",
            description: "Leading exchange",
            dateLaunched: "2017-07-14T00:00:00.000Z",
            notice: nil,
            countries: [],
            fiats: ["USD", "EUR"],
            tags: nil,
            type: "",
            makerFee: 0.02,
            takerFee: 0.04,
            weeklyVisits: 5123451,
            spotVolumeUsd: 66926283498.60113,
            spotVolumeLastUpdated: "2021-05-06T01:20:15.451Z",
            urls: ExchangeURLs(website: ["https://binance.com"], twitter: nil, blog: nil, chat: nil, fee: nil)
        )
    }
}

class ExchangeDetailViewControllerSpy: ExchangeDetailDisplayLogic {
    var displayDetailCalled = false
    var displayErrorCalled = false
    var displayedViewModel: ExchangeDetail.FetchDetail.ViewModel?
    var displayedErrorMessage: String?
    
    func displayDetail(viewModel: ExchangeDetail.FetchDetail.ViewModel) {
        displayDetailCalled = true
        displayedViewModel = viewModel
    }
    
    func displayError(viewModel: ExchangeDetail.Error.ViewModel) {
        displayErrorCalled = true
        displayedErrorMessage = viewModel.message
    }
}
