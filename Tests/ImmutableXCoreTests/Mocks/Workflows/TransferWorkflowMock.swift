import Foundation
@testable import ImmutableXCore

class TransferWorkflowCompanion {
    var throwableError: Error?
    var callsCount = 0
    var returnValue: CreateTransferResponse!
}

class TransferWorkflowMock: TransferWorkflow {
    static var companion: TransferWorkflowCompanion?

    static func mock(_ companion: TransferWorkflowCompanion) {
        self.companion = companion
    }

    static func resetMock() {
        companion = nil
    }

    override class func transfer(token: AssetModel, recipientAddress: String, signer: Signer, starkSigner: StarkSigner, transfersAPI: TransfersAPI.Type = TransfersAPI.self) async throws -> CreateTransferResponse {
        let companion = companion!

        if let error = companion.throwableError {
            throw error
        }

        companion.callsCount += 1
        return companion.returnValue
    }
}
