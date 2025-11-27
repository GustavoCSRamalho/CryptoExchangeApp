import UIKit

protocol ExchangesListCoordinatorProtocol {
    func navigateToExchangeDetail(exchange: ExchangeListing)
}

final class ExchangesListCoordinator: ExchangesListCoordinatorProtocol {
    weak var viewController: UIViewController?
    
    func navigateToExchangeDetail(exchange: ExchangeListing) {
        let detailViewController = ExchangeDetailFactory.make(exchange: exchange)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
