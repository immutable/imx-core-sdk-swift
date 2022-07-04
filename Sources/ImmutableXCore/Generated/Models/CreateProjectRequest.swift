//
// CreateProjectRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct CreateProjectRequest: Codable, JSONEncodable, Hashable {

    /** The company name */
    public private(set) var companyName: String
    /** The project contact email */
    public private(set) var contactEmail: String
    /** The project name */
    public private(set) var name: String

    public init(companyName: String, contactEmail: String, name: String) {
        self.companyName = companyName
        self.contactEmail = contactEmail
        self.name = name
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case companyName = "company_name"
        case contactEmail = "contact_email"
        case name
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(companyName, forKey: .companyName)
        try container.encode(contactEmail, forKey: .contactEmail)
        try container.encode(name, forKey: .name)
    }
}

