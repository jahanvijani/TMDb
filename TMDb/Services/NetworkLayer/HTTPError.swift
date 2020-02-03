//
//  APIError.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case sdkError(type: APISDKError)
    case transportError(type: TransportError, Error)
    case serverError(type: ServerError, HTTPURLResponse?)
}

enum APISDKError: Error {
    case notInitialized
    case malformedRequest
}

enum ServerError: Int, Error {
    case serverError = 500
    case unauthorized = 401
    case badRequest = 404
    case invalid = 400
    case unknown = -1
    case responseDecodingError = -2
}

public enum TransportError: Int, Error {
    case appTransportSecurityRequiresSecureConnection = -1022
    case backgroundSessionInUseByAnotherProcess = -996
    case backgroundSessionRequiresSharedContainer = -995
    case backgroundSessionWasDisconnected = -997
    case badServerResponse = -1011
    case badURL = -1000
    case callIsActive = -1019
    case cancelled = -999
    case cannotCloseFile = -3002
    case cannotConnectToHost = -1004
    case cannotCreateFile = -3000
    case cannotDecodeContentData = -1016
    case cannotDecodeRawData = -1015
    case cannotFindHost = -1003
    case cannotLoadFromNetwork = -2000
    case cannotMoveFile = -3005
    case cannotOpenFile = -3001
    case cannotParseResponse = -1017
    case cannotRemoveFile = -3004
    case cannotWriteToFile = -3003
    case clientCertificateRejected = -1205
    case clientCertificateRequired = -1206
    case dataLengthExceedsMaximum = -1103
    case dataNotAllowed = -1020
    case dnsLookupFailed = -1006
    case downloadDecodingFailedMidStream = -3006
    case downloadDecodingFailedToComplete = -3007
    case fileDoesNotExist = -1100
    case fileIsDirectory = -1101
    case fileOutsideSafeArea = -1104
    case httpTooManyRedirects = -1007
    case internationalRoamingOff = -1018
    case networkConnectionLost = -1005
    case noPermissionsToReadFile = -1102
    case notConnectedToInternet = -1009
    case redirectToNonExistentLocation = -1010
    case requestBodyStreamExhausted = -1021
    case resourceUnavailable = -1008
    case secureConnectionFailed = -1200
    case serverCertificateHasBadDate = -1201
    case serverCertificateHasUnknownRoot = -1203
    case serverCertificateNotYetValid = -1204
    case serverCertificateUntrusted = -1202
    case timedOut = -1001
    case unknown = -1
    case unsupportedURL = -1002
    case userAuthenticationRequired = -1013
    case userCancelledAuthentication = -1012
    case zeroByteResource = -1014
}
