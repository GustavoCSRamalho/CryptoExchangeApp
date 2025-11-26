import UIKit

enum ExchangeDetailFactory {
    static func make(exchange: ExchangeListing) -> UIViewController {
        let viewController = ExchangeDetailViewController(exchangeId: exchange.id)
        let interactor = ExchangeDetailInteractor()
        let presenter = ExchangeDetailPresenter()
        
        let network: NetworkServiceProtocol
        if UITestingHelper.isUITesting {
            let mockService = MockNetworkService()
            
            if UITestingHelper.shouldMockNetworkError {
                mockService.shouldReturnError = true
                
                if let errorType = UITestingHelper.mockErrorType {
                    switch errorType {
                    case "400":
                        mockService.errorToReturn = .serverError(statusCode: 400)
                    case "401":
                        mockService.errorToReturn = .serverError(statusCode: 401)
                    case "403":
                        mockService.errorToReturn = .serverError(statusCode: 403)
                    case "429":
                        mockService.errorToReturn = .serverError(statusCode: 429)
                    case "500":
                        mockService.errorToReturn = .serverError(statusCode: 500)
                    default:
                        mockService.errorToReturn = .unknown
                    }
                }
            }
            
            network = mockService
        } else {
            network = NetworkService()
        }
        
        let worker = ExchangeDetailWorker(networkService: network)
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        
        return viewController
    }
}
