//
// Mint.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct Mint: Codable, JSONEncodable, Hashable {

    /** Fee details */
    public private(set) var fees: [Fee]?
    /** Status of this mint */
    public private(set) var status: String
    /** Timestamp this mint was initiated */
    public private(set) var timestamp: String
    public private(set) var token: Token
    /** Sequential ID of transaction in Immutable X */
    public private(set) var transactionId: Int
    /** Ethereum address of the user to whom the asset has been minted */
    public private(set) var user: String

    public init(fees: [Fee]? = nil, status: String, timestamp: String, token: Token, transactionId: Int, user: String) {
        self.fees = fees
        self.status = status
        self.timestamp = timestamp
        self.token = token
        self.transactionId = transactionId
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case fees
        case status
        case timestamp
        case token
        case transactionId = "transaction_id"
        case user
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(fees, forKey: .fees)
        try container.encode(status, forKey: .status)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(token, forKey: .token)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encode(user, forKey: .user)
    }
}
