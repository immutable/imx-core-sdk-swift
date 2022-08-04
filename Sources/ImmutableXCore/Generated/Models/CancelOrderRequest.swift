//
// CancelOrderRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct CancelOrderRequest: Codable, Hashable {

    /** ID of the order */
    public private(set) var orderId: Int
    /** Payload signature */
    public private(set) var starkSignature: String

    public init(orderId: Int, starkSignature: String) {
        self.orderId = orderId
        self.starkSignature = starkSignature
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case orderId = "order_id"
        case starkSignature = "stark_signature"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(orderId, forKey: .orderId)
        try container.encode(starkSignature, forKey: .starkSignature)
    }
}

