//
// Deposit.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct Deposit: Codable, Hashable {

    /** Status of this deposit in ImmutableX */
    public private(set) var status: String
    /** Timestamp of the deposit */
    public private(set) var timestamp: String
    public private(set) var token: Token
    /** Sequential ID of this transaction within ImmutableX */
    public private(set) var transactionId: Int
    /** Ethereum address of the user making this deposit */
    public private(set) var user: String

    public init(status: String, timestamp: String, token: Token, transactionId: Int, user: String) {
        self.status = status
        self.timestamp = timestamp
        self.token = token
        self.transactionId = transactionId
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case status
        case timestamp
        case token
        case transactionId = "transaction_id"
        case user
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(token, forKey: .token)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encode(user, forKey: .user)
    }
}

