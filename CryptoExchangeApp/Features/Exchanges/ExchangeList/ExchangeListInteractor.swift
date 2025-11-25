import Foundation

protocol ExchangesInteractorProtocol {
    func fetchExchanges(request: Exchanges.FetchExchanges.Request)
    func selectExchange(request: Exchanges.SelectExchange.Request) -> Cryptocurrency?
}

final class ExchangesInteractor: ExchangesInteractorProtocol {
    var presenter: ExchangesPresenterProtocol?
    var worker: ExchangesWorkerProtocol?
    
    private var cryptocurrencies: [Cryptocurrency] = []
    
    func fetchExchanges(request: Exchanges.FetchExchanges.Request) {
        worker?.fetchCryptocurrencies { [weak self] result in
            switch result {
            case .success(let cryptocurrencies):
                self?.cryptocurrencies = cryptocurrencies
                let response = Exchanges.FetchExchanges.Response(cryptocurrencies: cryptocurrencies)
                self?.presenter?.presentExchanges(response: response)
            case .failure(let error):
                let response = Exchanges.Error.Response(message: error.localizedDescription)
                self?.presenter?.presentError(response: response)
            }
        }
    }
    
    func selectExchange(request: Exchanges.SelectExchange.Request) -> Cryptocurrency? {
        guard request.index < cryptocurrencies.count else { return nil }
        return cryptocurrencies[request.index]
    }
}
