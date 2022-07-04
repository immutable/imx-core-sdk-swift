//
// EncodeAssetResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct EncodeAssetResponse: Codable, JSONEncodable, Hashable {

    /** Stark encoded asset id */
    public private(set) var assetId: String
    /** Stark encoded asset type */
    public private(set) var assetType: String

    public init(assetId: String, assetType: String) {
        self.assetId = assetId
        self.assetType = assetType
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case assetId = "asset_id"
        case assetType = "asset_type"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(assetId, forKey: .assetId)
        try container.encode(assetType, forKey: .assetType)
    }
}
