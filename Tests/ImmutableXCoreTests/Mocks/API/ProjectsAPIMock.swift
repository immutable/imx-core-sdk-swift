import Foundation
@testable import ImmutableXCore

final class ProjectsAPIMock: ProjectsAPI {
    class GetProjectCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: Project!
    }

    class GetProjectsCompanion {
        var throwableError: Error?
        var callsCount = 0
        var returnValue: GetProjectsResponse!
    }

    static var getProjectCompanion: GetProjectCompanion?
    static var getProjectsCompanion: GetProjectsCompanion?

    static func mock(_ companion: GetProjectCompanion) {
        getProjectCompanion = companion
    }

    static func mock(_ companion: GetProjectsCompanion) {
        getProjectsCompanion = companion
    }

    static func resetMock() {
        getProjectCompanion = nil
        getProjectsCompanion = nil
    }

    override class func getProject(id: String, iMXSignature: String, iMXTimestamp: String) async throws -> Project {
        let companion = getProjectCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }

    override class func getProjects(
        iMXSignature: String,
        iMXTimestamp: String,
        pageSize: Int? = nil,
        cursor: String? = nil,
        orderBy: String? = nil,
        direction: String? = nil
    ) async throws -> GetProjectsResponse {
        let companion = getProjectsCompanion!
        companion.callsCount += 1

        if let error = companion.throwableError {
            throw error
        }

        return companion.returnValue
    }
}
