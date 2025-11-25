import Foundation

// MARK: - Cryptocurrency Models
struct Cryptocurrency: Codable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let cmcRank: Int?
    let numMarketPairs: Int?
    let circulatingSupply: Double?
    let totalSupply: Double?
    let maxSupply: Double?
    let infiniteSupply: Bool?
    let lastUpdated: String?
    let dateAdded: String?
    let tags: [String]?
    let platform: Platform?
    let quote: Quote?
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol, slug, tags, platform, quote
        case cmcRank = "cmc_rank"
        case numMarketPairs = "num_market_pairs"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case infiniteSupply = "infinite_supply"
        case lastUpdated = "last_updated"
        case dateAdded = "date_added"
    }
}

struct Platform: Codable {
    let id: Int?
    let name: String?
    let symbol: String?
    let slug: String?
    let tokenAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol, slug
        case tokenAddress = "token_address"
    }
}

struct Quote: Codable {
    private var currencies: [String: QuoteData]
    
    var usd: QuoteData? { currencies["USD"] }
    var btc: QuoteData? { currencies["BTC"] }
    var eur: QuoteData? { currencies["EUR"] }
    var eth: QuoteData? { currencies["ETH"] }
    

    var allCurrencies: [String: QuoteData] {
        return currencies
    }

    var sortedCurrencies: [(currency: String, data: QuoteData)] {
        return currencies.sorted { $0.key < $1.key }.map { (currency: $0.key, data: $0.value) }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempCurrencies: [String: QuoteData] = [:]
        
        for key in container.allKeys {
            if let quoteData = try? container.decode(QuoteData.self, forKey: key) {
                tempCurrencies[key.stringValue] = quoteData
            }
        }
        
        self.currencies = tempCurrencies
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        
        for (key, value) in currencies {
            let codingKey = DynamicCodingKeys(stringValue: key)!
            try container.encode(value, forKey: codingKey)
        }
    }
}

// MARK: - Dynamic Coding Keys para Quote
struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}

struct QuoteData: Codable {
    let price: Double?
    let volume24h: Double?
    let volumeChange24h: Double?
    let percentChange1h: Double?
    let percentChange24h: Double?
    let percentChange7d: Double?
    let marketCap: Double?
    let marketCapDominance: Double?
    let fullyDilutedMarketCap: Double?
    let lastUpdated: String?
    
    enum CodingKeys: String, CodingKey {
        case price
        case volume24h = "volume_24h"
        case volumeChange24h = "volume_change_24h"
        case percentChange1h = "percent_change_1h"
        case percentChange24h = "percent_change_24h"
        case percentChange7d = "percent_change_7d"
        case marketCap = "market_cap"
        case marketCapDominance = "market_cap_dominance"
        case fullyDilutedMarketCap = "fully_diluted_market_cap"
        case lastUpdated = "last_updated"
    }
}

struct CryptocurrencyListResponse: Codable {
    let data: [Cryptocurrency]
    let status: ResponseStatus
}

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

// MARK: - Cryptocurrency Detail Models
struct CryptocurrencyDetail: Codable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let description: String?
    let logo: String?
    let dateAdded: String?
    let tags: [String]?
    let platform: Platform?
    let urls: CryptoURLs?
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol, slug, description, logo, tags, platform, urls
        case dateAdded = "date_added"
    }
}

struct CryptoURLs: Codable {
    let website: [String]?
    let twitter: [String]?
    let reddit: [String]?
    let explorer: [String]?
    
    var primaryWebsite: String? {
        return website?.first
    }
}

struct CryptocurrencyDetailResponse: Codable {
    let data: [String: CryptocurrencyDetail]
    let status: ResponseStatus
}

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
