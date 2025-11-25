import Foundation

import Foundation

enum ExchangeDetail {
    enum FetchDetail {
        struct Request {
            let cryptocurrency: Cryptocurrency
        }
        
        struct Response {
            let exchange: Exchange
            let cryptocurrency: Cryptocurrency
        }
        
        struct ViewModel {
            let id: String
            let name: String
            let logoURL: String?
            let description: String
            let website: String
            let makerFee: String
            let takerFee: String
            let dateLaunched: String
            let currencies: [CurrencyViewModel]
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

struct CurrencyViewModel {
    let name: String
    let priceUSD: String
}
