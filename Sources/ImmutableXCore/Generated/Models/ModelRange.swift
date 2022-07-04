//
// ModelRange.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ModelRange: Codable, JSONEncodable, Hashable {

    /** Maximum value */
    public private(set) var max: Int?
    /** Minimum value */
    public private(set) var min: Int?

    public init(max: Int? = nil, min: Int? = nil) {
        self.max = max
        self.min = min
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case max
        case min
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(max, forKey: .max)
        try container.encodeIfPresent(min, forKey: .min)
    }
}
