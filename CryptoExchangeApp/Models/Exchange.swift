import Foundation

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


