import Foundation

// swiftlint:disable:next line_length
/// Status options available for ``ImmutableX/listTransfers(pageSize:cursor:orderBy:direction:user:receiver:status:minTimestamp:maxTimestamp:tokenType:tokenId:assetId:tokenAddress:tokenName:minQuantity:maxQuantity:metadata:)``
public enum ListTransfersStatus: String, CaseIterable {
    case success
    case failure

    /// Converts this enum to the type expected by the generated API code
    internal var asApiArgument: TransfersAPI.Status_listTransfers {
        switch self {
        case .success:
            return .success
        case .failure:
            return .failure
        }
    }
}
