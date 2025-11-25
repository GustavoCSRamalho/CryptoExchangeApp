import Foundation

enum Exchanges {
    enum FetchExchanges {
        struct Request {}
        
        struct Response {
            let cryptocurrencies: [Cryptocurrency]
        }
        
        struct ViewModel {
            let cryptocurrencies: [CryptocurrencyViewModel]
        }
    }
    
    enum SelectExchange {
        struct Request {
            let index: Int
        }
    }
    
    enum Error {
        struct Response {
            let message: String
        }
        
        struct ViewModel {
            let message: String
        }
    }
}

struct CryptocurrencyViewModel {
    let id: String
    let name: String
    let symbol: String
    let logoURL: String?
    let spotVolume: String
    let dateAdded: String
}

extension CryptocurrencyViewModel {
    init(cryptocurrency: Cryptocurrency) {
        self.id = "\(cryptocurrency.id)"
        self.name = cryptocurrency.name
        self.symbol = cryptocurrency.symbol
        
        self.logoURL = "https://s2.coinmarketcap.com/static/img/coins/64x64/\(cryptocurrency.id).png"
        
        // Formatar spot volume (volume 24h)
        if let volume = cryptocurrency.quote?.usd?.volume24h {
            let billion = 1_000_000_000.0
            let million = 1_000_000.0
            
            if volume >= billion {
                self.spotVolume = String(format: "$%.2fB", volume / billion)
            } else if volume >= million {
                self.spotVolume = String(format: "$%.2fM", volume / million)
            } else {
                self.spotVolume = String(format: "$%.2f", volume)
            }
        } else {
            self.spotVolume = "N/A"
        }
        
        if let dateString = cryptocurrency.dateAdded {
            let inputFormatter = ISO8601DateFormatter()
            inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            if let date = inputFormatter.date(from: dateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "dd/MM/yyyy"
                outputFormatter.locale = Locale(identifier: "pt_BR")

                self.dateAdded = outputFormatter.string(from: date)
            } else {
                self.dateAdded = dateString
            }
        } else {
            self.dateAdded = "N/A"
        }
    }
}
