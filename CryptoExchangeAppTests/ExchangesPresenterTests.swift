import XCTest
@testable import CryptoExchangeApp

final class ExchangesPresenterTests: XCTestCase {
    var sut: ExchangesListPresenter!
    var viewControllerSpy: ExchangesListViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        sut = ExchangesListPresenter()
        viewControllerSpy = ExchangesListViewControllerSpy()
        sut.viewController = viewControllerSpy
    }
    
    override func tearDown() {
        sut = nil
        viewControllerSpy = nil
        super.tearDown()
    }
    
    func testPresentExchanges() {
        // Given
        let exchange = makeExchangeListing()
        let response = Exchanges.FetchExchanges.Response(exchanges: [exchange])
        
        // When
        sut.presentExchanges(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayExchangesCalled)
        XCTAssertEqual(viewControllerSpy.displayedExchanges?.count, 1)
        XCTAssertEqual(viewControllerSpy.displayedExchanges?.first?.name, "Binance")
        XCTAssertEqual(viewControllerSpy.displayedExchanges?.first?.id, 270)
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
        let exchange = makeExchangeListing()
        let response = Exchanges.FetchExchanges.Response(exchanges: [exchange])
        
        // When
        sut.presentExchanges(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayExchangesCalled)
        XCTAssertEqual(viewControllerSpy.displayedExchanges?.first?.spotVolume, "$15.00B")
    }
    
    func testPresentExchangesWithDateFormatted() {
        // Given
        let exchange = makeExchangeListing()
        let response = Exchanges.FetchExchanges.Response(exchanges: [exchange])
        
        // When
        sut.presentExchanges(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayExchangesCalled)
        XCTAssertNotNil(viewControllerSpy.displayedExchanges?.first?.dateLaunched)
    }
    
    // MARK: - Helpers
    private func makeExchangeListing() -> ExchangeListing {
        return ExchangeListing(
            id: 270,
            name: "Binance",
            slug: "binance",
            numMarketPairs: 2000,
            spotVolumeUsd: 15000000000.0,
            dateLaunched: "2017-07-14T00:00:00.000Z"
        )
    }
}

class ExchangesListViewControllerSpy: ExchangesListDisplayLogic {
    var displayExchangesCalled = false
    var displayErrorCalled = false
    var displayedExchanges: [ExchangeViewModel]?
    var displayedErrorMessage: String?
    
    func displayExchanges(viewModel: Exchanges.FetchExchanges.ViewModel) {
        displayExchangesCalled = true
        displayedExchanges = viewModel.exchanges
    }
    
    func displayError(viewModel: Exchanges.Error.ViewModel) {
        displayErrorCalled = true
        displayedErrorMessage = viewModel.message
    }
}
