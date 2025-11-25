import Foundation

protocol ExchangeDetailPresenterProtocol {
    func presentDetail(response: ExchangeDetail.FetchDetail.Response)
    func presentError(response: ExchangeDetail.Error.Response)
}

final class ExchangeDetailPresenter: ExchangeDetailPresenterProtocol {
    weak var viewController: ExchangeDetailDisplayLogic?
    
    func presentDetail(response: ExchangeDetail.FetchDetail.Response) {
        let exchange = response.exchange
        let cryptocurrency = response.cryptocurrency
        
        var currencies: [CurrencyViewModel] = []
        
        if let quote = cryptocurrency.quote {
            for (currencySymbol, quoteData) in quote.sortedCurrencies {
                if let price = quoteData.price {
                    currencies.append(CurrencyViewModel(
                        name: currencySymbol,
                        priceUSD: formatPrice(price)
                    ))
                }
            }
        }
        
        if let fiats = exchange.fiats {
            for fiat in fiats {
                if !currencies.contains(where: { $0.name == fiat }) {
                    currencies.append(CurrencyViewModel(
                        name: fiat,
                        priceUSD: "Supported"
                    ))
                }
            }
        }
        
        if currencies.isEmpty {
            currencies.append(CurrencyViewModel(
                name: cryptocurrency.symbol,
                priceUSD: "N/A"
            ))
        }
        
        let viewModel = ExchangeDetail.FetchDetail.ViewModel(
            id: "\(exchange.id)",
            name: exchange.name,
            logoURL: exchange.logo,
            description: exchange.description ?? "No description available",
            website: exchange.urls?.primaryWebsite ?? "N/A",
            makerFee: formatFee(exchange.makerFee),
            takerFee: formatFee(exchange.takerFee),
            dateLaunched: formatDate(exchange.dateLaunched),
            currencies: currencies
        )
        
        viewController?.displayDetail(viewModel: viewModel)
    }
    
    func presentError(response: ExchangeDetail.Error.Response) {
        let viewModel = ExchangeDetail.Error.ViewModel(message: response.message)
        viewController?.displayError(viewModel: viewModel)
    }
    
    private func formatPrice(_ price: Double?) -> String {
        guard let price = price else { return "N/A" }
        
        if price >= 1 {
            return String(format: "$%.2f", price)
        } else if price >= 0.01 {
            return String(format: "$%.4f", price)
        } else {
            return String(format: "$%.8f", price)
        }
    }
    
    private func formatFee(_ fee: Double?) -> String {
        guard let fee = fee else { return "N/A" }
        return String(format: "%.2f%%", fee)
    }
    
    private func formatDate(_ dateString: String?) -> String {
        if let dateString = dateString {
            let inputFormatter = ISO8601DateFormatter()
            inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            if let date = inputFormatter.date(from: dateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "dd/MM/yyyy"
                outputFormatter.locale = Locale(identifier: "pt_BR")

                return outputFormatter.string(from: date)
            } else {
                return dateString
            }
        }
        return "N/A"
    }
}
