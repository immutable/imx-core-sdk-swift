//
// RegisterUserRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct RegisterUserRequest: Codable, JSONEncodable, Hashable {

    /** Eth signature */
    public private(set) var ethSignature: String
    /** The ether key of the user */
    public private(set) var etherKey: String
    /** Public stark key of the user */
    public private(set) var starkKey: String
    /** Payload signature */
    public private(set) var starkSignature: String

    public init(ethSignature: String, etherKey: String, starkKey: String, starkSignature: String) {
        self.ethSignature = ethSignature
        self.etherKey = etherKey
        self.starkKey = starkKey
        self.starkSignature = starkSignature
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case ethSignature = "eth_signature"
        case etherKey = "ether_key"
        case starkKey = "stark_key"
        case starkSignature = "stark_signature"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ethSignature, forKey: .ethSignature)
        try container.encode(etherKey, forKey: .etherKey)
        try container.encode(starkKey, forKey: .starkKey)
        try container.encode(starkSignature, forKey: .starkSignature)
    }
}
