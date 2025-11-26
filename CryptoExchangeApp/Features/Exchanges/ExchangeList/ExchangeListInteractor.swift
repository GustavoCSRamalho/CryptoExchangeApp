import Foundation

protocol ExchangesListInteractorProtocol {
    func fetchExchanges(request: Exchanges.FetchExchanges.Request)
    func selectExchange(request: Exchanges.SelectExchange.Request) -> ExchangeListing?
}

final class ExchangesListInteractor: ExchangesListInteractorProtocol {
    var presenter: ExchangesListPresenterProtocol?
    var worker: ExchangesListWorkerProtocol?
    var executor: AsyncExecutorProtocol?

    private var exchanges: [ExchangeListing] = []

    func fetchExchanges(request: Exchanges.FetchExchanges.Request) {
        worker?.fetchExchangeListings { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let listings):

                self.exchanges = listings
                self.presenter?.presentExchanges(
                    response: .init(exchanges: listings)
                )

                self.executor?.run { [weak self] in
                    guard let self else { return }
                    
                    let enriched = await self.fetchAllInfosInParallel(listings: listings)

                    self.exchanges = enriched
                    self.presenter?.presentExchanges(
                        response: .init(exchanges: enriched)
                    )
                }

            case .failure(let error):
                self.presenter?.presentError(
                    response: .init(message: error.localizedDescription)
                )
            }
        }
    }

    func selectExchange(request: Exchanges.SelectExchange.Request) -> ExchangeListing? {
        guard request.index < exchanges.count else { return nil }
        return exchanges[request.index]
    }
}

extension ExchangesListInteractor {
    private func fetchAllInfosInParallel(listings: [ExchangeListing]) async -> [ExchangeListing] {
        await withTaskGroup(of: ExchangeListing.self) { group in
            var result: [ExchangeListing] = []
            result.reserveCapacity(listings.count)
            
            for item in listings {
                group.addTask {
                    let info = await self.safeFetchInfo(id: item.id)

                    return ExchangeListing(
                        id: item.id,
                        name: item.name,
                        slug: item.slug,
                        logo: info?.logo ?? item.logo,
                        numMarketPairs: item.numMarketPairs,
                        spotVolumeUsd: item.spotVolumeUsd,
                        dateLaunched: item.dateLaunched
                    )
                }
            }
            
            for await enriched in group {
                result.append(enriched)
            }
            
            return result
        }
    }
    
    private func safeFetchInfo(id: Int) async -> Exchange? {
        await withCheckedContinuation { continuation in
            worker?.fetchExchangeInfo(id: id) { result in
                switch result {
                case .success(let info):
                    continuation.resume(returning: info)
                case .failure:
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
