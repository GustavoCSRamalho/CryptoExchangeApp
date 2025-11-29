import Foundation

protocol ExchangeDetailInteractorProtocol {
    func fetchDetail(request: ExchangeDetail.FetchDetail.Request)
}

final class ExchangeDetailInteractor: ExchangeDetailInteractorProtocol {
    var presenter: ExchangeDetailPresenterProtocol?
    var worker: ExchangeDetailWorkerProtocol?
    var executor: AsyncExecutorProtocol?
    
    func fetchDetail(request: ExchangeDetail.FetchDetail.Request) {
        let exchangeId = request.exchangeId
        
        executor?.run { [weak self] in
            guard let self else { return }
            
            do {
                let (exchange, assets) = try await self.fetchDetailData(for: exchangeId)
                
                self.presenter?.presentDetail(
                    response: .init(exchange: exchange, assets: assets)
                )
                
            } catch {
                self.presenter?.presentError(
                    response: .init(message: error.localizedDescription)
                )
            }
        }
    }
    
    // MARK: - Business Logic
    
    private func fetchDetailData(for id: Int) async throws -> (Exchange, [ExchangeAsset]) {
        async let exchangeTask = fetchExchangeInfoAsync(id: id)
        async let assetsTask = fetchExchangeAssetsAsync(id: id)
        
        let exchange = try await exchangeTask
        let assets = (try? await assetsTask) ?? []
        
        return (exchange, assets)
    }
    
    // MARK: - Network Helpers
    
    private func fetchExchangeInfoAsync(id: Int) async throws -> Exchange {
        try await withCheckedThrowingContinuation { continuation in
            worker?.fetchExchangeInfo(id: id) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    private func fetchExchangeAssetsAsync(id: Int) async throws -> [ExchangeAsset] {
        try await withCheckedThrowingContinuation { continuation in
            worker?.fetchExchangeAssets(id: id) { result in
                continuation.resume(with: result)
            }
        }
    }
}
