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
                        priceUSD: L10n.General.supported
                    ))
                }
            }
        }
        
        if currencies.isEmpty {
            currencies.append(CurrencyViewModel(
                name: cryptocurrency.symbol,
                priceUSD: L10n.General.notAvailable
            ))
        }
        
        let viewModel = ExchangeDetail.FetchDetail.ViewModel(
            id: "\(exchange.id)",
            name: exchange.name,
            logoURL: exchange.logo,
            description: exchange.description ?? L10n.Detail.noDescription,
            website: exchange.urls?.primaryWebsite ?? L10n.General.notAvailable,
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
        guard let price = price else { return L10n.General.notAvailable }
        
        if price >= 1 {
            return String(format: "$%.2f", price)
        } else if price >= 0.01 {
            return String(format: "$%.4f", price)
        } else {
            return String(format: "$%.8f", price)
        }
    }
    
    private func formatFee(_ fee: Double?) -> String {
        guard let fee = fee else { return L10n.General.notAvailable }
        return String(format: "%.2f%%", fee)
    }
    
    private func formatDate(_ dateString: String?) -> String {
        if let dateString = dateString {
            let inputFormatter = ISO8601DateFormatter()
            inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            if let date = inputFormatter.date(from: dateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.locale = Locale(identifier: L10n.DateFormat.locale)

                return outputFormatter.string(from: date)
            } else {
                return dateString
            }
        }
        return L10n.General.notAvailable
    }
}
```

## RESUMO DAS MUDANÇAS:

### ✅ Adicionado no Localizable.strings:
```
"date.format.short" = "dd/MM/yyyy";     // pt-BR
"date.format.short" = "MM/dd/yyyy";     // en

"date.format.full" = "dd/MM/yyyy HH:mm"; // pt-BR
"date.format.full" = "MM/dd/yyyy HH:mm"; // en

"date.locale" = "pt_BR";  // pt-BR
"date.locale" = "en_US";  // en
