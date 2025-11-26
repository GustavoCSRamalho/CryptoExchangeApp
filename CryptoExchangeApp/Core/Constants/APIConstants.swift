import Foundation

enum APIConstants {
    // MARK: - Base URL
    static let baseURL = "https://pro-api.coinmarketcap.com/v1"
    
    // MARK: - Headers
    static let apiKeyHeader = "X-CMC_PRO_API_KEY"
    
    // MARK: - API Key
    static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "CMC_API_KEY") as? String,
              !key.isEmpty,
              key != "$(API_KEY)" else {
            fatalError("CMC_API_KEY não encontrada no Info.plist")
        }
        return key
    }
}
