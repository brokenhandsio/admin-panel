import Vapor
import Fluent
import Leaf
import Flash

public protocol LoginControllerType: RouteCollection {
    func loginHandler(_ req: Request) async throws -> View
    func loginPostHandler(_ req: Request) async throws -> Response
    func logoutHandler(_ req: Request) async throws -> Response
}

public final class LoginController: LoginControllerType {
    public func boot(routes: RoutesBuilder) throws {
        routes.get("login", use: loginHandler)
        let credentialsAuthRoutes = routes.grouped(
            AdminPanelUser.CredentialsAuthenticatior()
        )
        credentialsAuthRoutes.post("login", use: loginPostHandler)
        routes.get("logout", use: logoutHandler)
    }

    // MARK: Login

    public func loginPostHandler(_ req: Request) async throws -> Response {
        let endpoints = req.adminPanel.config.endpoints
        try req.auth.require(AdminPanelUser.self)
        guard let user = req.auth.get(AdminPanelUser.self) else {
            return req.redirect(to: endpoints.login)
                .flash(.error, "Invalid email and/or password")
        }
        req.session.authenticate(user)
        return req.redirect(to: endpoints.dashboard)
            .flash(.success, "Logged in as \(user.email)")
    }

    public func loginHandler(_ req: Request) async throws -> View {
        if req.auth.has(AdminPanelUser.self) {
            return try await req.leaf.render(req.adminPanel.config.views.dashboard.index)
        } else {
            return try await req
            .flash(.error, "Please log in")
            .leaf.render(
                req.adminPanel.config.views.login.index,
                RenderLogin(queryString: req.url.query)
            )
        }
    }

    // MARK: Log out

    public func logoutHandler(_ req: Request) async throws -> Response {
        let endpoints = req.adminPanel.config.endpoints
        req.auth.logout(AdminPanelUser.self)
        return req.redirect(to: endpoints.login).flash(.success, "Logged out")
    }
}

fileprivate extension LoginController {
    private struct Login: Decodable {
        private let email: String
        private let password: String
    }

    struct RenderLogin: Encodable {
        fileprivate let queryString: String?
    }
}
