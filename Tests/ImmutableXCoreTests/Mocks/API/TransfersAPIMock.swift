import Foundation
@testable import ImmutableXCore

class TransfersAPIMockGetSignableCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: GetSignableTransferResponse!
}

class TransfersAPIMockCreateTransferCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: CreateTransferResponse!
}

class TransfersAPIMockGetTransferCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: Transfer!
}

class TransfersAPIMockListTransfersCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: ListTransfersResponse!
}

final class TransfersAPIMock: TransfersAPI {
    static var getSignableCompanion: TransfersAPIMockGetSignableCompanion?
    static var createTransferCompanion: TransfersAPIMockCreateTransferCompanion?
    static var getTransferCompanion: TransfersAPIMockGetTransferCompanion?
    static var listTransfersCompanion: TransfersAPIMockListTransfersCompanion?

    static func mock(_ companion: TransfersAPIMockGetSignableCompanion) {
        getSignableCompanion = companion
    }

    static func mock(_ companion: TransfersAPIMockCreateTransferCompanion) {
        createTransferCompanion = companion
    }

    static func mock(_ companion: TransfersAPIMockGetTransferCompanion) {
        getTransferCompanion = companion
    }

    static func mock(_ companion: TransfersAPIMockListTransfersCompanion) {
        listTransfersCompanion = companion
    }

    static func resetMock() {
        getSignableCompanion = nil
        createTransferCompanion = nil
        getTransferCompanion = nil
        listTransfersCompanion = nil
    }

    // MARK: - getSignableTransfer

    override class func getSignableTransfer(
        getSignableTransferRequestV2: GetSignableTransferRequest
    ) async throws -> GetSignableTransferResponse {
        let companion = getSignableCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - createTransfer

    override class func createTransfer(
        xImxEthAddress: String,
        xImxEthSignature: String,
        createTransferRequestV2: CreateTransferRequest
    ) async throws -> CreateTransferResponse {
        let companion = createTransferCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - listTransfers

    override class func listTransfers(
        pageSize: Int? = nil,
        cursor: String? = nil,
        orderBy: TransfersAPI.OrderBy_listTransfers? = nil,
        direction: String? = nil,
        user: String? = nil,
        receiver: String? = nil,
        status: TransfersAPI.Status_listTransfers? = nil,
        minTimestamp: String? = nil,
        maxTimestamp: String? = nil,
        tokenType: String? = nil,
        tokenId: String? = nil,
        assetId: String? = nil,
        tokenAddress: String? = nil,
        tokenName: String? = nil,
        minQuantity: String? = nil,
        maxQuantity: String? = nil,
        metadata: String? = nil
    ) async throws -> ListTransfersResponse {
        let companion = listTransfersCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - getTransfer

    override class func getTransfer(id: String) async throws -> Transfer {
        let companion = getTransferCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }
}
