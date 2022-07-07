@_exported import LGNLog
@_exported import Logging

#if canImport(Vapor)

import Vapor

public extension LGNLogger {
    public struct Middleware: AsyncMiddleware {
        public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
            try await Logger.$current.withValue(request.logger) {
                try await next.respond(to: request)
            }
        }
    }
}

#endif
