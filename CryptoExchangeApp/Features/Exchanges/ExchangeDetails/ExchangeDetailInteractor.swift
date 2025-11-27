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
            guard let self = self else { return }
            
            let result = await self.fetchDetailData(for: exchangeId)
            
            switch result {
            case .success(let (exchange, assets)):
                self.presenter?.presentDetail(
                    response: .init(exchange: exchange, assets: assets)
                )
            case .failure(let error):
                self.presenter?.presentError(
                    response: .init(message: error.localizedDescription)
                )
            }
        }
    }
    
    // MARK: - Business Logic
    
    private func fetchDetailData(for id: Int) async -> Result<(Exchange, [ExchangeAsset]), NetworkError> {
        do {
            async let exchangeTask = fetchExchangeInfoAsync(id: id)
            async let assetsTask = fetchExchangeAssetsAsync(id: id)
            
            let exchange = try await exchangeTask
            let assets = (try? await assetsTask) ?? []
            
            return .success((exchange, assets))
            
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
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
