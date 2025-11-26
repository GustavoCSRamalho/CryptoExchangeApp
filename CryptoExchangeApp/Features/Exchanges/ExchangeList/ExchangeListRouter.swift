import UIKit

protocol ExchangesRouterProtocol {
    func navigateToExchangeDetail(exchange: ExchangeListing)
}

final class ExchangesRouter: ExchangesRouterProtocol {
    weak var viewController: UIViewController?
    
    func navigateToExchangeDetail(exchange: ExchangeListing) {
        let detailViewController = ExchangeDetailFactory.make(exchange: exchange)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
