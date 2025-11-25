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
        let cryptocurrency = makeCryptocurrency()
        let exchange = makeExchange()
        workerSpy.fetchExchangeInfoResult = .success(exchange)
        let request = ExchangeDetail.FetchDetail.Request(cryptocurrency: cryptocurrency)
        
        // When
        sut.fetchDetail(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentDetailCalled)
        XCTAssertEqual(presenterSpy.presentedExchange?.name, "Binance")
    }
    
    func testFetchDetailFailure() {
        // Given
        let cryptocurrency = makeCryptocurrency()
        workerSpy.fetchExchangeInfoResult = .failure(.noData)
        let request = ExchangeDetail.FetchDetail.Request(cryptocurrency: cryptocurrency)
        
        // When
        sut.fetchDetail(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentErrorCalled)
        XCTAssertFalse(presenterSpy.presentDetailCalled)
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

class ExchangeDetailPresenterSpy: ExchangeDetailPresenterProtocol {
    var presentDetailCalled = false
    var presentErrorCalled = false
    var presentedExchange: Exchange?
    
    func presentDetail(response: ExchangeDetail.FetchDetail.Response) {
        presentDetailCalled = true
        presentedExchange = response.exchange
    }
    
    func presentError(response: ExchangeDetail.Error.Response) {
        presentErrorCalled = true
    }
}

class ExchangeDetailWorkerSpy: ExchangeDetailWorkerProtocol {
    var fetchExchangeInfoResult: Result<Exchange, NetworkError>?
    
    func fetchExchangeInfo(id: String, completion: @escaping (Result<Exchange, NetworkError>) -> Void) {
        if let result = fetchExchangeInfoResult {
            completion(result)
        }
    }
}
