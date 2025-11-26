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

// MARK: - Exchange Info Models
struct Exchange: Codable {
    let id: Int
    let name: String
    let slug: String
    let logo: String?
    let description: String?
    let dateLaunched: String?
    let notice: String?
    let countries: [String]?
    let fiats: [String]?
    let tags: [String]?
    let type: String?
    let makerFee: Double?
    let takerFee: Double?
    let weeklyVisits: Int?
    let spotVolumeUsd: Double?
    let spotVolumeLastUpdated: String?
    let urls: ExchangeURLs?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, logo, description, notice, countries, fiats, tags, type, urls
        case dateLaunched = "date_launched"
        case makerFee = "maker_fee"
        case takerFee = "taker_fee"
        case weeklyVisits = "weekly_visits"
        case spotVolumeUsd = "spot_volume_usd"
        case spotVolumeLastUpdated = "spot_volume_last_updated"
    }
}

struct ExchangeURLs: Codable {
    let website: [String]?
    let twitter: [String]?
    let blog: [String]?
    let chat: [String]?
    let fee: [String]?
    
    var primaryWebsite: String? {
        return website?.first
    }
}

struct ExchangeInfoResponse: Codable {
    let data: [String: Exchange]
    let status: ResponseStatus
}

// MARK: - Exchange Assets Models
struct ExchangeAsset: Codable {
    let walletAddress: String?
    let balance: Double?
    let platform: AssetPlatform
    let currency: AssetCurrency
    
    enum CodingKeys: String, CodingKey {
        case balance, platform, currency
        case walletAddress = "wallet_address"
    }
}

struct AssetPlatform: Codable {
    let cryptoId: Int
    let symbol: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case symbol, name
        case cryptoId = "crypto_id"
    }
}

struct AssetCurrency: Codable {
    let cryptoId: Int
    let priceUsd: Double
    let symbol: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case symbol, name
        case cryptoId = "crypto_id"
        case priceUsd = "price_usd"
    }
}

struct ExchangeAssetsResponse: Codable {
    let data: [ExchangeAsset]
    let status: ResponseStatus
}

// MARK: - Response Status
struct ResponseStatus: Codable {
    let timestamp: String
    let errorCode: Int
    let errorMessage: String?
    let elapsed: Int
    let creditCount: Int
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case elapsed
        case creditCount = "credit_count"
    }
}
