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
        let exchange = makeExchange()
        let assets = makeExchangeAssets()
        let response = ExchangeDetail.FetchDetail.Response(exchange: exchange, assets: assets)
        
        // When
        sut.presentDetail(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayDetailCalled)
        XCTAssertEqual(viewControllerSpy.displayedViewModel?.name, "Binance")
        XCTAssertEqual(viewControllerSpy.displayedViewModel?.makerFee, "0.10%")
        XCTAssertEqual(viewControllerSpy.displayedViewModel?.takerFee, "0.10%")
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
        let exchange = makeExchange()
        let assets = makeExchangeAssets()
        let response = ExchangeDetail.FetchDetail.Response(exchange: exchange, assets: assets)
        
        // When
        sut.presentDetail(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayDetailCalled)
        XCTAssertEqual(viewControllerSpy.displayedViewModel?.currencies.count, 2)
        XCTAssertEqual(viewControllerSpy.displayedViewModel?.currencies.first?.name, "Origin Protocol")
    }
    
    func testPresentDetailWithoutAssets() {
        // Given
        let exchange = makeExchange()
        let response = ExchangeDetail.FetchDetail.Response(exchange: exchange, assets: [])
        
        // When
        sut.presentDetail(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayDetailCalled)
        XCTAssertGreaterThan(viewControllerSpy.displayedViewModel?.currencies.count ?? 0, 0)
    }
    
    func testPresentDetailFormatsPrice() {
        // Given
        let exchange = makeExchange()
        let assets = makeExchangeAssets()
        let response = ExchangeDetail.FetchDetail.Response(exchange: exchange, assets: assets)
        
        // When
        sut.presentDetail(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayDetailCalled)
        XCTAssertTrue(viewControllerSpy.displayedViewModel?.currencies.first?.priceUSD.contains("$") ?? false)
    }
    
    // MARK: - Helpers
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
            makerFee: 0.10,
            takerFee: 0.10,
            weeklyVisits: 5123451,
            spotVolumeUsd: 66926283498.60113,
            spotVolumeLastUpdated: "2021-05-06T01:20:15.451Z",
            urls: ExchangeURLs(website: ["https://binance.com"], twitter: nil, blog: nil, chat: nil, fee: nil)
        )
    }
    
    private func makeExchangeAssets() -> [ExchangeAsset] {
        return [
            ExchangeAsset(
                walletAddress: "0x5a52e96bacdabb82fd05763e25335261b270efcb",
                balance: 45000000,
                platform: AssetPlatform(cryptoId: 1027, symbol: "ETH", name: "Ethereum"),
                currency: AssetCurrency(cryptoId: 5117, priceUsd: 0.10241799413549, symbol: "OGN", name: "Origin Protocol")
            ),
            ExchangeAsset(
                walletAddress: "0xf977814e90da44bfa03b6295a0616a897441acec",
                balance: 400000000,
                platform: AssetPlatform(cryptoId: 1027, symbol: "ETH", name: "Ethereum"),
                currency: AssetCurrency(cryptoId: 5824, priceUsd: 0.00251174724338, symbol: "SLP", name: "Smooth Love Potion")
            )
        ]
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
