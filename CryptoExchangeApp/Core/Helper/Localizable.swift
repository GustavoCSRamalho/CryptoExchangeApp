import Foundation

enum L10n {

    // MARK: - General
    enum General {
        static let ok = localized("general.ok")
        static let cancel = localized("general.cancel")
        static let retry = localized("general.retry")
        static let waitRetry = localized("general.wait_retry")
        static let error = localized("general.error")
        static let loading = localized("general.loading")
        static let noData = localized("general.no_data")
        static let notAvailable = localized("general.not_available")
        static let supported = localized("general.supported")
    }

    // MARK: - Navigation
    enum Navigation {
        static let back = localized("nav.back")
        static let close = localized("nav.close")
    }

    // MARK: - Exchanges List
    enum Exchanges {
        static let title = localized("exchanges.title")
        static let emptyState = localized("exchanges.empty_state")
        static let pullToRefresh = localized("exchanges.pull_to_refresh")

        static func volume(_ value: String) -> String {
            return String(format: localized("exchanges.cell.volume"), value)
        }

        static func launched(_ date: String) -> String {
            return String(format: localized("exchanges.cell.launched"), date)
        }
    }

    // MARK: - Exchange Detail
    enum Detail {
        static let title = localized("detail.title")
        static let website = localized("detail.website")
        static let makerFee = localized("detail.maker_fee")
        static let takerFee = localized("detail.taker_fee")
        static let dateLaunched = localized("detail.date_launched")
        static let tradingPairs = localized("detail.trading_pairs")
        static let noDescription = localized("detail.no_description")

        static func idLabel(_ id: String) -> String {
            return String(format: localized("detail.id_label"), id)
        }
    }

    // MARK: - Date Format
    enum DateFormat {
        static let short = localized("date.format.short")
        static let full = localized("date.format.full")
        static let locale = localized("date.locale")
    }

    // MARK: - Errors
    enum Error {
        enum Title {
            static let badRequest = localized("error.title.bad_request")
            static let unauthorized = localized("error.title.unauthorized")
            static let forbidden = localized("error.title.forbidden")
            static let rateLimit = localized("error.title.rate_limit")
            static let serverError = localized("error.title.server_error")
            static let noData = localized("error.title.no_data")
            static let decoding = localized("error.title.decoding")
            static let network = localized("error.title.network")
            static let unknown = localized("error.title.unknown")
        }

        enum Message {
            static let badRequest = localized("error.message.bad_request")
            static let badRequestId = localized("error.message.bad_request_id")
            static let unauthorized = localized("error.message.unauthorized")
            static let forbidden = localized("error.message.forbidden")
            static let rateLimit = localized("error.message.rate_limit")
            static func serverError(_ code: Int) -> String {
                return String(format: localized("error.message.server_error"), "\(code)")
            }
            static let noData = localized("error.message.no_data")
            static let decoding = localized("error.message.decoding")
            static let unknown = localized("error.message.unknown")
            static let invalidURL = localized("error.message.invalidURL")


            static func network(_ error: String) -> String {
                return String(format: localized("error.message.network"), error)
            }
        }
    }

    // MARK: - Accessibility
    enum Accessibility {
        static func cryptoLogo(_ name: String) -> String {
            return String(format: localized("accessibility.crypto_logo"), name)
        }

        static let backButton = localized("accessibility.back_button")
        static let refresh = localized("accessibility.refresh")
        static let errorIcon = localized("accessibility.error_icon")
    }

    // MARK: - Helper
    private static func localized(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
