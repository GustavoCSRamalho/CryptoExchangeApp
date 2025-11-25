import Foundation

protocol ExchangeDetailInteractorProtocol {
    func fetchDetail(request: ExchangeDetail.FetchDetail.Request)
}

final class ExchangeDetailInteractor: ExchangeDetailInteractorProtocol {
    var presenter: ExchangeDetailPresenterProtocol?
    var worker: ExchangeDetailWorkerProtocol?
    
    func fetchDetail(request: ExchangeDetail.FetchDetail.Request) {
        let cryptocurrency = request.cryptocurrency
        let cryptoId = "\(cryptocurrency.id)"
        
        worker?.fetchExchangeInfo(id: cryptoId) { [weak self] result in
            switch result {
            case .success(let exchange):
                let response = ExchangeDetail.FetchDetail.Response(
                    exchange: exchange,
                    cryptocurrency: cryptocurrency
                )
                self?.presenter?.presentDetail(response: response)
                
            case .failure(let error):
                let response = ExchangeDetail.Error.Response(message: error.localizedDescription)
                self?.presenter?.presentError(response: response)
            }
        }
    }
}
