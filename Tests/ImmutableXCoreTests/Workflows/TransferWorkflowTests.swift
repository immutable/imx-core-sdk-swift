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

    func testTransferFlowFailsOnSignableTransferError() async throws {
        let signableCompanion = TransfersAPIMockGetSignableCompanion()
        signableCompanion.throwableError = DummyError.something
        transfersAPI.mock(signableCompanion)

        do {
            _ = try await TransferWorkflow.transfer(
                token: erc721Token,
                recipientAddress: recipientAddress,
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                transfersAPI: transfersAPI
            )

            XCTFail("Should have not succeeded")
        } catch {
            XCTAssertTrue(error is WorkflowError, "non-Immutable X errors gets mapped to WorkflowError")
        }
    }

    func testTransferFlowFailsOnInvalidSignableResponse() async throws {
        let signableCompanion = TransfersAPIMockGetSignableCompanion()
        signableCompanion.returnValue = signableTransferResponseStub2
        transfersAPI.mock(signableCompanion)

        do {
            _ = try await TransferWorkflow.transfer(
                token: erc721Token,
                recipientAddress: recipientAddress,
                signer: SignerMock(),
                starkSigner: StarkSignerMock(),
                transfersAPI: transfersAPI
            )

            XCTFail("Should have not succeeded")
        } catch {
            XCTAssertTrue(error is WorkflowError, "non-Immutable X errors gets mapped to WorkflowError")
        }
    }
}
