import UIKit

protocol ExchangesListRouterProtocol {
    func navigateToExchangeDetail(exchange: ExchangeListing)
}

final class ExchangesListRouter: ExchangesListRouterProtocol {
    weak var viewController: UIViewController?
    
    func navigateToExchangeDetail(exchange: ExchangeListing) {
        let detailViewController = ExchangeDetailFactory.make(exchange: exchange)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
