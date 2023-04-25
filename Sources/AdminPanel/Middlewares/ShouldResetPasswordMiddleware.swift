import Flash
import Vapor

/// Basic middleware to redirect users that needs to reset their password to the supplied path
public struct ShouldResetPasswordMiddleware: AsyncMiddleware {
    
    /// The path to redirect to
    let path: String
    
    /// Initialise the `ShouldResetPasswordMiddleware`
    ///
    /// - parameters:
    ///    - path: The path to redirect to if the user needs to reset their password
    public init(path: String) {
        self.path = path
    }
    
    /// See `Middleware.respond`.
    public func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let user = req.auth.get(AdminPanelUser.self)
        guard let user else {
            return try await next.respond(to: req)
        }
        guard
            user.shouldResetPassword,
            req.url.path != path
        else {
            return try await next.respond(to: req)
        }
        
        return req.redirect(to: path)
            .flash(.info, "Please update your password.")
    }
    
    /// Use this middleware to redirect users away from
    /// protected content to a edit page when they need to reset their password
    public static func shouldResetPassword(
        path: String = "/admin/users/me/edit"
    ) -> ShouldResetPasswordMiddleware {
        return ShouldResetPasswordMiddleware(path: path)
    }
}
