import Foundation

// swiftlint:disable:next line_length
/// Ordering options available for ``ImmutableX/listCollections(pageSize:cursor:orderBy:direction:blacklist:whitelist:keyword:)``
public enum ListCollectionsOrderBy: String, CaseIterable {
    case name
    case address
    case projectId = "project_id"
    case createdAt = "created_at"
    case updatedAt = "updated_at"

    /// Converts this enum to the type expected by the generated API code
    internal var asApiArgument: CollectionsAPI.OrderBy_listCollections {
        switch self {
        case .name:
            return .name
        case .address:
            return .address
        case .projectId:
            return .projectId
        case .createdAt:
            return .createdAt
        case .updatedAt:
            return .updatedAt
        }
    }
}
