import Foundation
enum Exchanges {
    enum FetchExchanges {
        struct Request {}
        
        struct Response {
            let exchanges: [ExchangeListing]
        }
        
        struct ViewModel {
            let exchanges: [ExchangeViewModel]
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

struct ExchangeViewModel {
    let id: Int
    let name: String
    let slug: String
    let logoURL: String?
    let spotVolume: String
    let dateLaunched: String
    
    init(exchange: ExchangeListing) {
        self.id = exchange.id
        self.name = exchange.name
        self.slug = exchange.slug
        self.logoURL = exchange.logo
        
        if let volume = exchange.spotVolumeUsd {
            if volume >= 1_000_000_000 {
                self.spotVolume = String(format: "$%.2fB", volume / 1_000_000_000)
            } else if volume >= 1_000_000 {
                self.spotVolume = String(format: "$%.2fM", volume / 1_000_000)
            } else {
                self.spotVolume = String(format: "$%.2f", volume)
            }
        } else {
            self.spotVolume = "N/A"
        }
        
        if let launched = exchange.dateLaunched {
            let formatter = ISO8601DateFormatter()
            if let date = formatter.date(from: launched) {
                let displayFormatter = DateFormatter()
                displayFormatter.dateStyle = .medium
                self.dateLaunched = displayFormatter.string(from: date)
            } else {
                self.dateLaunched = launched
            }
        } else {
            self.dateLaunched = "N/A"
        }
    }
}
