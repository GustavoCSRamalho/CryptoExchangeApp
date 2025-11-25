import Foundation

protocol ExchangesPresenterProtocol {
    func presentExchanges(response: Exchanges.FetchExchanges.Response)
    func presentError(response: Exchanges.Error.Response)
}

final class ExchangesPresenter: ExchangesPresenterProtocol {
    weak var viewController: ExchangesDisplayLogic?
    
    func presentExchanges(response: Exchanges.FetchExchanges.Response) {
        let cryptoViewModels = response.cryptocurrencies.map { CryptocurrencyViewModel(cryptocurrency: $0) }
        let viewModel = Exchanges.FetchExchanges.ViewModel(cryptocurrencies: cryptoViewModels)
        viewController?.displayExchanges(viewModel: viewModel)
    }
    
    func presentError(response: Exchanges.Error.Response) {
        let viewModel = Exchanges.Error.ViewModel(message: response.message)
        viewController?.displayError(viewModel: viewModel)
    }
}
