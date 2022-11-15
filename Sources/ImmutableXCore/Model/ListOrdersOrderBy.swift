import Foundation

// swiftlint:disable:next line_length
/// Ordering options available for ``ImmutableX/listOrders(pageSize:cursor:orderBy:direction:user:status:minTimestamp:maxTimestamp:updatedMinTimestamp:updatedMaxTimestamp:buyTokenType:buyTokenId:buyAssetId:buyTokenAddress:buyTokenName:buyMinQuantity:buyMaxQuantity:buyMetadata:sellTokenType:sellTokenId:sellAssetId:sellTokenAddress:sellTokenName:sellMinQuantity:sellMaxQuantity:sellMetadata:auxiliaryFeePercentages:auxiliaryFeeRecipients:includeFees:)``
public enum ListOrdersOrderBy: String, CaseIterable {
    case createdAt = "created_at"
    case expiredAt = "expired_at"
    case sellQuantity = "sell_quantity"
    case buyQuantity = "buy_quantity"
    case buyQuantityWithFees = "buy_quantity_with_fees"
    case updatedAt = "updated_at"

    /// Converts this enum to the type expected by the generated API code
    internal var asApiArgument: OrdersAPI.OrderBy_listOrders {
        switch self {
        case .createdAt:
            return .createdAt
        case .expiredAt:
            return .expiredAt
        case .sellQuantity:
            return .sellQuantity
        case .buyQuantity:
            return .buyQuantity
        case .buyQuantityWithFees:
            return .buyQuantityWithFees
        case .updatedAt:
            return .updatedAt
        }
    }
}
