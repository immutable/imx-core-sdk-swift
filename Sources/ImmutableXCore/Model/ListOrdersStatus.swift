import Foundation

// swiftlint:disable:next line_length
/// Status options available for ``ImmutableX/listOrders(pageSize:cursor:orderBy:direction:user:status:minTimestamp:maxTimestamp:updatedMinTimestamp:updatedMaxTimestamp:buyTokenType:buyTokenId:buyAssetId:buyTokenAddress:buyTokenName:buyMinQuantity:buyMaxQuantity:buyMetadata:sellTokenType:sellTokenId:sellAssetId:sellTokenAddress:sellTokenName:sellMinQuantity:sellMaxQuantity:sellMetadata:auxiliaryFeePercentages:auxiliaryFeeRecipients:includeFees:)``
public enum ListOrdersStatus: String, CaseIterable {
    case active
    case filled
    case cancelled
    case expired
    case inactive

    /// Converts this enum to the type expected by the generated API code
    internal var asApiArgument: OrdersAPI.Status_listOrders {
        switch self {
        case .active:
            return .active
        case .filled:
            return .filled
        case .cancelled:
            return .cancelled
        case .expired:
            return .expired
        case .inactive:
            return .inactive
        }
    }
}
