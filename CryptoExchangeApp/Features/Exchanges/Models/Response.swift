struct ExchangeAssetsResponse: Codable {
    let data: [ExchangeAsset]
    let status: ResponseStatus
}


struct ExchangeInfoResponse: Codable {
    let data: [String: Exchange]
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
