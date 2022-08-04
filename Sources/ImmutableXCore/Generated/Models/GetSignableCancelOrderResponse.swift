//
// GetSignableCancelOrderResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct GetSignableCancelOrderResponse: Codable, Hashable {

    /** ID of the order to be cancelled */
    public private(set) var orderId: Int
    /** Hash of the payload to be signed for cancel order */
    public private(set) var payloadHash: String
    /** Message to sign from wallet to confirm cancel order */
    public private(set) var signableMessage: String

    public init(orderId: Int, payloadHash: String, signableMessage: String) {
        self.orderId = orderId
        self.payloadHash = payloadHash
        self.signableMessage = signableMessage
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case orderId = "order_id"
        case payloadHash = "payload_hash"
        case signableMessage = "signable_message"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(orderId, forKey: .orderId)
        try container.encode(payloadHash, forKey: .payloadHash)
        try container.encode(signableMessage, forKey: .signableMessage)
    }
}

