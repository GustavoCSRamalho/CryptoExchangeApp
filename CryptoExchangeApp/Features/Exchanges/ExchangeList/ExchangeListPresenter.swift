import Foundation

protocol ExchangesPresenterProtocol {
    func presentExchanges(response: Exchanges.FetchExchanges.Response)
    func presentError(response: Exchanges.Error.Response)
}

final class ExchangesPresenter: ExchangesPresenterProtocol {
    weak var viewController: ExchangesDisplayLogic?
    
    func presentExchanges(response: Exchanges.FetchExchanges.Response) {
        let exchangeViewModels = response.exchanges.map { ExchangeViewModel(exchange: $0) }
        let viewModel = Exchanges.FetchExchanges.ViewModel(exchanges: exchangeViewModels)
        viewController?.displayExchanges(viewModel: viewModel)
    }
    
    func presentError(response: Exchanges.Error.Response) {
        let viewModel = Exchanges.Error.ViewModel(message: response.message)
        viewController?.displayError(viewModel: viewModel)
    }
}
