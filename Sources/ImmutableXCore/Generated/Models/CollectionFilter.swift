//
// CollectionFilter.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct CollectionFilter: Codable, Hashable {

    /** Key of this property */
    public private(set) var key: String?
    public private(set) var range: ModelRange?
    /** Type of this filter */
    public private(set) var type: String?
    /** List of possible values for this property */
    public private(set) var value: [String]?

    public init(key: String? = nil, range: ModelRange? = nil, type: String? = nil, value: [String]? = nil) {
        self.key = key
        self.range = range
        self.type = type
        self.value = value
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case key
        case range
        case type
        case value
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(key, forKey: .key)
        try container.encodeIfPresent(range, forKey: .range)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(value, forKey: .value)
    }
}

