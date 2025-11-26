import Foundation

protocol ExchangesInteractorProtocol {
    func fetchExchanges(request: Exchanges.FetchExchanges.Request)
    func selectExchange(request: Exchanges.SelectExchange.Request) -> ExchangeListing?
}

final class ExchangesInteractor: ExchangesInteractorProtocol {
    var presenter: ExchangesPresenterProtocol?
    var worker: ExchangesWorkerProtocol?
    
    private var exchanges: [ExchangeListing] = []
    
    func fetchExchanges(request: Exchanges.FetchExchanges.Request) {
        worker?.fetchExchangeListings { [weak self] result in
            switch result {
            case .success(let exchangeListings):
                self?.exchanges = exchangeListings
                let response = Exchanges.FetchExchanges.Response(exchanges: exchangeListings)
                self?.presenter?.presentExchanges(response: response)
            case .failure(let error):
                let response = Exchanges.Error.Response(message: error.localizedDescription)
                self?.presenter?.presentError(response: response)
            }
        }
    }
    
    func selectExchange(request: Exchanges.SelectExchange.Request) -> ExchangeListing? {
        guard request.index < exchanges.count else { return nil }
        return exchanges[request.index]
    }
}
