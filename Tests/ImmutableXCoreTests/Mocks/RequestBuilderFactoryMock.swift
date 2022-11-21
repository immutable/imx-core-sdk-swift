import Foundation
@testable import ImmutableXCore

class RequestBuilderFactoryMock: RequestBuilderFactory {
    static var returnValue: Result<Response<Any>, ErrorResponse>!

    func mock(_ result: Result<Response<some Any>, ErrorResponse>) {
        switch result {
        case let .success(response):
            RequestBuilderFactoryMock.returnValue = .success(Response(response: HTTPURLResponse(), body: response.body))
        case let .failure(error):
            RequestBuilderFactoryMock.returnValue = .failure(error)
        }
    }

    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type {
        RequestBuilderMock.self
    }

    func getBuilder<T>() -> RequestBuilder<T>.Type where T: Decodable {
        RequestBuilderMock.self
    }
}

class RequestBuilderMock<T>: RequestBuilder<T> {
    @discardableResult
    override open func execute(
        _ apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue,
        _ completion: @escaping (_ result: Swift.Result<Response<T>, ErrorResponse>) -> Void
    ) -> RequestTask {
        switch RequestBuilderFactoryMock.returnValue {
        case let .success(response):
            completion(.success(Response(response: HTTPURLResponse(), body: response.body as! T)))
        case let .failure(error):
            completion(.failure(error))
        case .none:
            fatalError("Return type not set")
        }

        return RequestTask()
    }
}
