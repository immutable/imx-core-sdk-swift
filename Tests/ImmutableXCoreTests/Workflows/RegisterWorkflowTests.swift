import Foundation
@testable import ImmutableXCore
import XCTest

final class RegisterWorkflowTests: XCTestCase {
    let usersAPI = UsersAPIMock.self

    override func setUp() {
        super.setUp()
        usersAPI.resetMock()

        let usersCompanion = UsersAPIMockGetUsersCompanion()
        usersCompanion.returnValue = GetUsersApiResponse(accounts: [])
        usersAPI.mock(usersCompanion)

        let signableCompanion = UsersAPIMockGetSignableCompanion()
        signableCompanion.returnValue = signableRegistrationOffchainResponseStub1
        usersAPI.mock(signableCompanion)

        let registerCompanion = UsersAPIMockRegisterCompanion()
        registerCompanion.returnValue = registerUserResponseStub1
        usersAPI.mock(registerCompanion)
    }

    func testRegistrationSuccessfulForUnregistredUser() async throws {
        let usersCompanion = UsersAPIMockGetUsersCompanion()
        usersCompanion.throwableError = ErrorResponse.error(404, nil, nil, DummyError.something)
        usersAPI.mock(usersCompanion)

        let response = try await RegisterWorkflow.registerOffchain(signer: SignerMock(), starkSigner: StarkSignerMock(), usersAPI: usersAPI)
        XCTAssertEqual(response, true)
        XCTAssertEqual(usersAPI.getUsersCompanion?.callsCount, 1)
        XCTAssertEqual(usersAPI.getSignableCompanion?.callsCount, 1)
        XCTAssertEqual(usersAPI.registerCompanion?.callsCount, 1)
    }

    func testRegistrationReturnsFalseForAlreadyRegistredUser() async throws {
        let usersCompanion = UsersAPIMockGetUsersCompanion()
        usersCompanion.returnValue = usersAPIResponseStub1
        usersAPI.mock(usersCompanion)

        let response = try await RegisterWorkflow.registerOffchain(signer: SignerMock(), starkSigner: StarkSignerMock(), usersAPI: usersAPI)
        XCTAssertEqual(response, false)
        XCTAssertEqual(usersAPI.getUsersCompanion?.callsCount, 1)
        XCTAssertEqual(usersAPI.getSignableCompanion?.callsCount, 0)
        XCTAssertEqual(usersAPI.registerCompanion?.callsCount, 0)
    }

    func testRegistrationThrowsIfGetUsersResponseFails() async {
        let usersCompanion = UsersAPIMockGetUsersCompanion()
        usersCompanion.throwableError = ErrorResponse.error(400, nil, nil, DummyError.something)
        usersAPI.mock(usersCompanion)

        let error = await XCTAssertThrowsErrorAsync {
            _ = try await RegisterWorkflow.registerOffchain(signer: SignerMock(), starkSigner: StarkSignerMock(), usersAPI: self.usersAPI)
        }

        XCTAssertTrue(error is ImmutableXError)
        XCTAssertEqual(usersAPI.getUsersCompanion?.callsCount, 1)
        XCTAssertEqual(usersAPI.getSignableCompanion?.callsCount, 0)
        XCTAssertEqual(usersAPI.registerCompanion?.callsCount, 0)
    }

    func testRegistrationThrowsIfSignableResponseFails() async {
        let signableCompanion = UsersAPIMockGetSignableCompanion()
        signableCompanion.throwableError = DummyError.something
        usersAPI.mock(signableCompanion)

        let error = await XCTAssertThrowsErrorAsync {
            _ = try await RegisterWorkflow.registerOffchain(signer: SignerMock(), starkSigner: StarkSignerMock(), usersAPI: self.usersAPI)
        }

        XCTAssertTrue(error is ImmutableXError)
        XCTAssertEqual(usersAPI.getUsersCompanion?.callsCount, 1)
        XCTAssertEqual(usersAPI.getSignableCompanion?.callsCount, 1)
        XCTAssertEqual(usersAPI.registerCompanion?.callsCount, 0)
    }

    func testRegistrationThrowsIfRegisterResponseFails() async {
        let registerCompanion = UsersAPIMockRegisterCompanion()
        registerCompanion.throwableError = DummyError.something
        usersAPI.mock(registerCompanion)

        let error = await XCTAssertThrowsErrorAsync {
            _ = try await RegisterWorkflow.registerOffchain(signer: SignerMock(), starkSigner: StarkSignerMock(), usersAPI: self.usersAPI)
        }

        XCTAssertTrue(error is ImmutableXError)
        XCTAssertEqual(usersAPI.getUsersCompanion?.callsCount, 1)
        XCTAssertEqual(usersAPI.getSignableCompanion?.callsCount, 1)
        XCTAssertEqual(usersAPI.registerCompanion?.callsCount, 1)
    }
}
