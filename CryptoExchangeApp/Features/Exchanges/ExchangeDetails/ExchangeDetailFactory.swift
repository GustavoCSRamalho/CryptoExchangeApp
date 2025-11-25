import UIKit

enum ExchangeDetailFactory {
    static func make(cryptocurrency: Cryptocurrency) -> UIViewController {
        let viewController = ExchangeDetailViewController(cryptocurrency: cryptocurrency)
        let interactor = ExchangeDetailInteractor()
        let presenter = ExchangeDetailPresenter()
        let network = NetworkService()
        let worker = ExchangeDetailWorker(networkService: network)
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        
        return viewController
    }
}
