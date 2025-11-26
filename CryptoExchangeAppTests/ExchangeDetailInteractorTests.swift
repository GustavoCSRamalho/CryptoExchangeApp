import XCTest
@testable import CryptoExchangeApp

final class ExchangeDetailInteractorTests: XCTestCase {
    var sut: ExchangeDetailInteractor!
    var presenterSpy: ExchangeDetailPresenterSpy!
    var workerSpy: ExchangeDetailWorkerSpy!
    
    override func setUp() {
        super.setUp()
        sut = ExchangeDetailInteractor()
        presenterSpy = ExchangeDetailPresenterSpy()
        workerSpy = ExchangeDetailWorkerSpy()
        sut.presenter = presenterSpy
        sut.worker = workerSpy
    }
    
    override func tearDown() {
        sut = nil
        presenterSpy = nil
        workerSpy = nil
        super.tearDown()
    }
    
    func testFetchDetailSuccess() {
        // Given
        let exchange = makeExchange()
        let assets = makeExchangeAssets()
        workerSpy.fetchExchangeInfoResult = .success(exchange)
        workerSpy.fetchExchangeAssetsResult = .success(assets)
        let request = ExchangeDetail.FetchDetail.Request(exchangeId: 270)
        
        // When
        sut.fetchDetail(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentDetailCalled)
        XCTAssertEqual(presenterSpy.presentedExchange?.name, "Binance")
        XCTAssertEqual(presenterSpy.presentedAssets?.count, 2)
    }
    
    func testFetchDetailInfoFailure() {
        // Given
        workerSpy.fetchExchangeInfoResult = .failure(.noData)
        let request = ExchangeDetail.FetchDetail.Request(exchangeId: 270)
        
        // When
        sut.fetchDetail(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentErrorCalled)
        XCTAssertFalse(presenterSpy.presentDetailCalled)
    }
    
    func testFetchDetailAssetsFailure() {
        // Given
        let exchange = makeExchange()
        workerSpy.fetchExchangeInfoResult = .success(exchange)
        workerSpy.fetchExchangeAssetsResult = .failure(.noData)
        let request = ExchangeDetail.FetchDetail.Request(exchangeId: 270)
        
        // When
        sut.fetchDetail(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentErrorCalled)
        XCTAssertFalse(presenterSpy.presentDetailCalled)
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

class ExchangeDetailPresenterSpy: ExchangeDetailPresenterProtocol {
    var presentDetailCalled = false
    var presentErrorCalled = false
    var presentedExchange: Exchange?
    var presentedAssets: [ExchangeAsset]?
    
    func presentDetail(response: ExchangeDetail.FetchDetail.Response) {
        presentDetailCalled = true
        presentedExchange = response.exchange
        presentedAssets = response.assets
    }
    
    func presentError(response: ExchangeDetail.Error.Response) {
        presentErrorCalled = true
    }
}

class ExchangeDetailWorkerSpy: ExchangeDetailWorkerProtocol {
    var fetchExchangeInfoResult: Result<Exchange, NetworkError>?
    var fetchExchangeAssetsResult: Result<[ExchangeAsset], NetworkError>?
    
    func fetchExchangeInfo(id: Int, completion: @escaping (Result<Exchange, NetworkError>) -> Void) {
        if let result = fetchExchangeInfoResult {
            completion(result)
        }
    }
    
    func fetchExchangeAssets(id: Int, completion: @escaping (Result<[ExchangeAsset], NetworkError>) -> Void) {
        if let result = fetchExchangeAssetsResult {
            completion(result)
        }
    }
}
