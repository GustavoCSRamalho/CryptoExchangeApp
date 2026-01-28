import XCTest
@testable import CryptoExchangeApp

final class ExchangesInteractorTests: XCTestCase {
    var sut: ExchangesListInteractor!
    var presenterSpy: ExchangesListPresenterSpy!
    var workerSpy: ExchangesListWorkerSpy!
    var executorSpy: AsyncExecutorMock!
    
    override func setUp() {
        super.setUp()
        executorSpy = AsyncExecutorMock()
        presenterSpy = ExchangesListPresenterSpy()
        workerSpy = ExchangesListWorkerSpy()

        sut = ExchangesListInteractor(
            presenter: presenterSpy,
            worker: workerSpy,
            executor: executorSpy
        )
    }
    
    override func tearDown() {
        sut = nil
        presenterSpy = nil
        workerSpy = nil
        super.tearDown()
    }
    
    func testFetchExchangesSuccess() async {
        workerSpy.fetchExchangeListingsResult = .success([makeExchangeListing()])

        sut.fetchExchanges(request: .init())

        await executorSpy.executedOperations.first?()

        XCTAssertTrue(presenterSpy.presentExchangesCalled)
    }
    
    func testFetchExchangesFailure() async throws {
        // Given
        workerSpy.fetchExchangeListingsResult = .failure(.networkFailure(NSError(domain: "test", code: -1)))
        let request = Exchanges.FetchExchanges.Request()
        
        // When
        sut.fetchExchanges(request: request)
        
        await executorSpy.executedOperations.first?()
        
        // Then
        XCTAssertTrue(presenterSpy.presentErrorCalled)
        XCTAssertFalse(presenterSpy.presentExchangesCalled)
    }
    
    func testSelectExchangeValidIndex() async {
        // Given
        let exchanges = [makeExchangeListing()]
        workerSpy.fetchExchangeListingsResult = .success(exchanges)

        // When
        sut.fetchExchanges(request: Exchanges.FetchExchanges.Request())

        await executorSpy.executedOperations.first?()

        let request = Exchanges.SelectExchange.Request(index: 0)
        let result = sut.selectExchange(request: request)
            
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, 270)
    }
    
    func testSelectExchangeInvalidIndex() {
        // Given
        let exchanges = [makeExchangeListing()]
        workerSpy.fetchExchangeListingsResult = .success(exchanges)
        sut.fetchExchanges(request: Exchanges.FetchExchanges.Request())
        let request = Exchanges.SelectExchange.Request(index: 10)
        
        // When
        let result = sut.selectExchange(request: request)
        
        // Then
        XCTAssertNil(result)
    }
    
    // MARK: - Helpers
    private func makeExchangeListing() -> ExchangeListing {
        return ExchangeListing(
            id: 270,
            name: "Binance",
            slug: "binance",
            logo: "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png",
            numMarketPairs: 2000,
            spotVolumeUsd: 15000000000.0,
            dateLaunched: "2017-07-14T00:00:00.000Z"
        )
    }
}

// MARK: - Spies
class ExchangesListPresenterSpy: ExchangesListPresenterProtocol {
    var presentExchangesCalled = false
    var presentErrorCalled = false
    var presentedExchanges: [ExchangeListing]?
    
    func presentExchanges(response: Exchanges.FetchExchanges.Response) {
        presentExchangesCalled = true
        presentedExchanges = response.exchanges
    }
    
    func presentError(response: Exchanges.Error.Response) {
        presentErrorCalled = true
    }
}

class ExchangesListWorkerSpy: ExchangesListWorkerProtocol {

    var fetchExchangeInfoResult: Result<Exchange, NetworkError>?
    var fetchExchangeListingsResult: Result<[ExchangeListing], NetworkError>?

    func fetchExchangeListings(completion: @escaping (Result<[ExchangeListing], NetworkError>) -> Void) {
        completion(fetchExchangeListingsResult ?? .success([]))
    }

    func fetchExchangeInfo(id: Int, completion: @escaping (Result<Exchange, NetworkError>) -> Void) {
        completion(fetchExchangeInfoResult ?? .failure(.noData))
    }
}
