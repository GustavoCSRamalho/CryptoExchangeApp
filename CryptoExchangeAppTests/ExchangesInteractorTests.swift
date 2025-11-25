import XCTest
@testable import CryptoExchangeApp

final class ExchangesInteractorTests: XCTestCase {
    var sut: ExchangesInteractor!
    var presenterSpy: ExchangesPresenterSpy!
    var workerSpy: ExchangesWorkerSpy!
    
    override func setUp() {
        super.setUp()
        sut = ExchangesInteractor()
        presenterSpy = ExchangesPresenterSpy()
        workerSpy = ExchangesWorkerSpy()
        sut.presenter = presenterSpy
        sut.worker = workerSpy
    }
    
    override func tearDown() {
        sut = nil
        presenterSpy = nil
        workerSpy = nil
        super.tearDown()
    }
    
    func testFetchExchangesSuccess() {
        // Given
        let expectedCryptocurrencies = [makeCryptocurrency()]
        workerSpy.fetchCryptocurrenciesResult = .success(expectedCryptocurrencies)
        let request = Exchanges.FetchExchanges.Request()
        
        // When
        sut.fetchExchanges(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentExchangesCalled)
        XCTAssertEqual(presenterSpy.presentedCryptocurrencies?.count, 1)
        XCTAssertEqual(presenterSpy.presentedCryptocurrencies?.first?.id, 1)
    }
    
    func testFetchExchangesFailure() {
        // Given
        workerSpy.fetchCryptocurrenciesResult = .failure(.networkFailure(NSError(domain: "test", code: -1)))
        let request = Exchanges.FetchExchanges.Request()
        
        // When
        sut.fetchExchanges(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentErrorCalled)
        XCTAssertFalse(presenterSpy.presentExchangesCalled)
    }
    
    func testSelectExchangeValidIndex() {
        // Given
        let cryptocurrencies = [makeCryptocurrency()]
        workerSpy.fetchCryptocurrenciesResult = .success(cryptocurrencies)
        sut.fetchExchanges(request: Exchanges.FetchExchanges.Request())
        let request = Exchanges.SelectExchange.Request(index: 0)
        
        // When
        let result = sut.selectExchange(request: request)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, 1)
    }
    
    func testSelectExchangeInvalidIndex() {
        // Given
        let cryptocurrencies = [makeCryptocurrency()]
        workerSpy.fetchCryptocurrenciesResult = .success(cryptocurrencies)
        sut.fetchExchanges(request: Exchanges.FetchExchanges.Request())
        let request = Exchanges.SelectExchange.Request(index: 10)
        
        // When
        let result = sut.selectExchange(request: request)
        
        // Then
        XCTAssertNil(result)
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
}

// MARK: - Spies
class ExchangesPresenterSpy: ExchangesPresenterProtocol {
    var presentExchangesCalled = false
    var presentErrorCalled = false
    var presentedCryptocurrencies: [Cryptocurrency]?
    
    func presentExchanges(response: Exchanges.FetchExchanges.Response) {
        presentExchangesCalled = true
        presentedCryptocurrencies = response.cryptocurrencies
    }
    
    func presentError(response: Exchanges.Error.Response) {
        presentErrorCalled = true
    }
}

class ExchangesWorkerSpy: ExchangesWorkerProtocol {
    var fetchCryptocurrenciesResult: Result<[Cryptocurrency], NetworkError>?
    
    func fetchCryptocurrencies(completion: @escaping (Result<[Cryptocurrency], NetworkError>) -> Void) {
        if let result = fetchCryptocurrenciesResult {
            completion(result)
        }
    }
}
