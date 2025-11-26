import Foundation

protocol ExchangeDetailInteractorProtocol {
    func fetchDetail(request: ExchangeDetail.FetchDetail.Request)
}

final class ExchangeDetailInteractor: ExchangeDetailInteractorProtocol {
    var presenter: ExchangeDetailPresenterProtocol?
    var worker: ExchangeDetailWorkerProtocol?
    
    func fetchDetail(request: ExchangeDetail.FetchDetail.Request) {
        let exchangeId = request.exchangeId
        
        worker?.fetchExchangeInfo(id: exchangeId) { [weak self] infoResult in
            switch infoResult {
            case .success(let exchange):
                self?.worker?.fetchExchangeAssets(id: exchangeId) { assetsResult in
                    switch assetsResult {
                    case .success(let assets):
                        let response = ExchangeDetail.FetchDetail.Response(
                            exchange: exchange,
                            assets: assets
                        )
                        self?.presenter?.presentDetail(response: response)
                        
                    case .failure(let error):
                        let response = ExchangeDetail.Error.Response(message: error.localizedDescription)
                        self?.presenter?.presentError(response: response)
                    }
                }
                
            case .failure(let error):
                let response = ExchangeDetail.Error.Response(message: error.localizedDescription)
                self?.presenter?.presentError(response: response)
            }
        }
    }
}
