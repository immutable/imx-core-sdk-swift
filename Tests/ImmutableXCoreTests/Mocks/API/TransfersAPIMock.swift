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

final class TransfersAPIMock: TransfersAPI {
    static var getSignableCompanion: TransfersAPIMockGetSignableCompanion?
    static var createTransferCompanion: TransfersAPIMockCreateTransferCompanion?

    static func mock(_ companion: TransfersAPIMockGetSignableCompanion) {
        getSignableCompanion = companion
    }

    static func mock(_ companion: TransfersAPIMockCreateTransferCompanion) {
        createTransferCompanion = companion
    }

    static func resetMock() {
        getSignableCompanion = nil
        createTransferCompanion = nil
    }

    // MARK: - getSignableTransfer

    override class func getSignableTransfer(getSignableTransferRequestV2: GetSignableTransferRequest) async throws -> GetSignableTransferResponse {
        let companion = getSignableCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }

    // MARK: - createTransfer

    override class func createTransfer(createTransferRequestV2: CreateTransferRequest, xImxEthAddress: String? = nil, xImxEthSignature: String? = nil) async throws -> CreateTransferResponse {
        let companion = createTransferCompanion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }
}
