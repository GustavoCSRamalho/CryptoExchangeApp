import UIKit

enum ExchangesFactory {
    static func make() -> UIViewController {
        let viewController = ExchangesViewController()
        let interactor = ExchangesInteractor()
        let presenter = ExchangesPresenter()
        let network = NetworkService()
        let router = ExchangesRouter()
        let worker = ExchangesWorker(networkService: network)
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
