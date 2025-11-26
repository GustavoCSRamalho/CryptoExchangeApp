//
//  ExchangeList.swift
//  CryptoExchangeApp
//
//  Created by Gustavo Ramalho on 26/11/25.
//

// MARK: - Exchange Listing Models
struct ExchangeListing: Codable {
    let id: Int
    let name: String
    let slug: String
    let numMarketPairs: Int?
    let spotVolumeUsd: Double?
    let dateLaunched: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case numMarketPairs = "num_market_pairs"
        case spotVolumeUsd = "spot_volume_usd"
        case dateLaunched = "date_launched"
    }
}

struct ExchangeListingsResponse: Codable {
    let data: [ExchangeListing]
    let status: ResponseStatus
}
