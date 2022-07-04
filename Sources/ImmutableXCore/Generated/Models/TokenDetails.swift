//
// TokenDetails.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct TokenDetails: Codable, JSONEncodable, Hashable {

    /** Number of decimals for token */
    public private(set) var decimals: String
    /** Url for the icon of the token */
    public private(set) var imageUrl: String
    /** Full name of the token (e.g. Ether) */
    public private(set) var name: String
    /** Quantum for token */
    public private(set) var quantum: String
    /** Ticker symbol for token (e.g. ETH/USDC/IMX) */
    public private(set) var symbol: String
    /** Address of the ERC721 contract */
    public private(set) var tokenAddress: String

    public init(decimals: String, imageUrl: String, name: String, quantum: String, symbol: String, tokenAddress: String) {
        self.decimals = decimals
        self.imageUrl = imageUrl
        self.name = name
        self.quantum = quantum
        self.symbol = symbol
        self.tokenAddress = tokenAddress
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case decimals
        case imageUrl = "image_url"
        case name
        case quantum
        case symbol
        case tokenAddress = "token_address"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(decimals, forKey: .decimals)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(name, forKey: .name)
        try container.encode(quantum, forKey: .quantum)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(tokenAddress, forKey: .tokenAddress)
    }
}
