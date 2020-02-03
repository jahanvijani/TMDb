//
//  Error+Extensions.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

extension HTTPError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .sdkError(_):
            return ""
        case .transportError(let transportError, _):
            switch transportError {
            case .dataNotAllowed, .notConnectedToInternet, .internationalRoamingOff:
                return "network_error_message".localized()
            case .networkConnectionLost, .timedOut:
                return "network_timeout_error_message".localized()
            default:
                return "other_network_error_message".localized()
            }
        case .serverError(let serverError, _):
            switch serverError {
            case .serverError, .unauthorized, .badRequest, .invalid:
                return "server_error_message".localized()
            default:
                return "unknown_error_message".localized()
            }
        }
    }
}
