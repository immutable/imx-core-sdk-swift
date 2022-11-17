import Foundation

// swiftlint:disable:next line_length
/// Ordering options available for ``ImmutableX/listTransfers(pageSize:cursor:orderBy:direction:user:receiver:status:minTimestamp:maxTimestamp:tokenType:tokenId:assetId:tokenAddress:tokenName:minQuantity:maxQuantity:metadata:)``
public enum ListTransfersOrderBy: String, CaseIterable {
    case transactionId = "transaction_id"
    case updatedAt = "updated_at"
    case createdAt = "created_at"
    case senderEtherKey = "sender_ether_key"
    case receiverEtherKey = "receiver_ether_key"

    /// Converts this enum to the type expected by the generated API code
    internal var asApiArgument: TransfersAPI.OrderBy_listTransfers {
        switch self {
        case .transactionId:
            return .transactionId
        case .updatedAt:
            return .updatedAt
        case .createdAt:
            return .createdAt
        case .senderEtherKey:
            return .senderEtherKey
        case .receiverEtherKey:
            return .receiverEtherKey
        }
    }
}
