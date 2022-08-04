//
// CollectionDetails.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct CollectionDetails: Codable, Hashable {

    /** URL of the icon of the collection */
    public private(set) var iconUrl: String?
    /** Name of the collection */
    public private(set) var name: String

    public init(iconUrl: String?, name: String) {
        self.iconUrl = iconUrl
        self.name = name
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case iconUrl = "icon_url"
        case name
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(iconUrl, forKey: .iconUrl)
        try container.encode(name, forKey: .name)
    }
}

