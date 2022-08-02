@testable import ImmutableXCore
import XCTest

final class TransferWorkflowTests: XCTestCase {
    let transfersAPI = TransfersAPIMock.self
    let erc20Token = ERC20Asset(quantity: "10", tokenAddress: "address", decimals: 18)
    let ethToken = ETHAsset(quantity: "10")
    let erc721Token = ERC721Asset(tokenAddress: "address", tokenId: "id")
    let recipientAddress = "0xa76e3eeb2f7143165618ab8feaabcd395b6fac7f"

    override func setUp() {
        super.setUp()
        transfersAPI.resetMock()

        let signableCompanion = TransfersAPIMockGetSignableCompanion()
        signableCompanion.returnValue = signableTransferResponseStub1
        transfersAPI.mock(signableCompanion)

        let createTransferCompanion = TransfersAPIMockCreateTransferCompanion()
        createTransferCompanion.returnValue = createTransferResponseStub1
        transfersAPI.mock(createTransferCompanion)
    }

    func testTransferERC20FlowSuccess() async throws {
        let response = try await TransferWorkflow.transfer(
            token: erc20Token,
            recipientAddress: recipientAddress,
            signer: SignerMock(),
            starkSigner: StarkSignerMock(),
            transfersAPI: transfersAPI
        )

        XCTAssertEqual(response, createTransferResponseStub1)
    }

    func testTransferETHFlowSuccess() async throws {
        let response = try await TransferWorkflow.transfer(
            token: ethToken,
            recipientAddress: recipientAddress,
            signer: SignerMock(),
            starkSigner: StarkSignerMock(),
            transfersAPI: transfersAPI
        )

        XCTAssertEqual(response, createTransferResponseStub1)
    }

    func testTransferERC721FlowSuccess() async throws {
        let response = try await TransferWorkflow.transfer(
            token: erc721Token,
            recipientAddress: recipientAddress,
            signer: SignerMock(),
            starkSigner: StarkSignerMock(),
            transfersAPI: transfersAPI
        )

        XCTAssertEqual(response, createTransferResponseStub1)
    }

    func testTransferFlowFailsOnSignableTransferError() {
        let signableCompanion = TransfersAPIMockGetSignableCompanion()
        signableCompanion.throwableError = DummyError.something
        transfersAPI.mock(signableCompanion)

        XCTAssertThrowsErrorAsync { [unowned self] in
            _ = try await TransferWorkflow.transfer(
                token: erc721Token,
                recipientAddress: recipientAddress,
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                transfersAPI: self.transfersAPI
            )
        }
    }

    func testTransferFlowFailsOnInvalidSignableResponse() {
        let signableCompanion = TransfersAPIMockGetSignableCompanion()
        signableCompanion.returnValue = signableTransferResponseStub2
        transfersAPI.mock(signableCompanion)

        XCTAssertThrowsErrorAsync { [unowned self] in
            _ = try await TransferWorkflow.transfer(
                token: erc721Token,
                recipientAddress: recipientAddress,
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                transfersAPI: self.transfersAPI
            )
        }
    }
}
