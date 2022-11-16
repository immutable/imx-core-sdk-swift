import Foundation

// swiftlint:disable:next line_length
/// Ordering options available for ``ImmutableX/listAssets(pageSize:cursor:orderBy:direction:user:status:name:metadata:sellOrders:buyOrders:includeFees:collection:updatedMinTimestamp:updatedMaxTimestamp:auxiliaryFeePercentages:auxiliaryFeeRecipients:)``
public enum ListAssetsOrderBy: String, CaseIterable {
    case updatedAt = "updated_at"
    case name

    /// Converts this enum to the type expected by the generated API code
    internal var asApiArgument: AssetsAPI.OrderBy_listAssets {
        switch self {
        case .updatedAt:
            return .updatedAt
        case .name:
            return .name
        }
    }
}
