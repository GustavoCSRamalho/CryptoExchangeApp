import UIKit

protocol ExchangesRouterProtocol {
    func navigateToExchangeDetail(cryptocurrency: Cryptocurrency)
}

final class ExchangesRouter: ExchangesRouterProtocol {
    weak var viewController: UIViewController?
    
    func navigateToExchangeDetail(cryptocurrency: Cryptocurrency) {
        let detailViewController = ExchangeDetailFactory.make(cryptocurrency: cryptocurrency)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
