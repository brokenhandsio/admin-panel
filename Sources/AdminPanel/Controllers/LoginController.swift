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
        let adminAuthSessionRoutes = routes
            .grouped(AdminPanelUser.sessionAuthenticator())
            .grouped("admin")
        adminAuthSessionRoutes.get("login", use: loginHandler)
        adminAuthSessionRoutes.get("logout", use: logoutHandler)

        let credentialsAuthRoutes = adminAuthSessionRoutes.grouped(
            AdminPanelUser.credentialsAuthenticator()
        )
        credentialsAuthRoutes.post("login", use: loginPostHandler)
    }

    // MARK: Login

    public func loginPostHandler(_ req: Request) async throws -> Response {
        let endpoints = req.adminPanel.config.endpoints
        if let user = req.auth.get(AdminPanelUser.self) {
            try await user.generateToken().save(on: req.db)
            return req.redirect(to: endpoints.dashboard)
                .flash(.success, "Logged in as \(user.email)")
        } else {
            return req.redirect(to: endpoints.login)
                .flash(.error, "Ivalid email and/or password")
        }
    }

    public func loginHandler(_ req: Request) async throws -> View {
        let endpoints = req.adminPanel.config.endpoints
        if req.auth.has(AdminPanelUser.self) {
            return try await req.leaf.render(req.adminPanel.config.endpoints.dashboard)
        } else {
            return try await req.leaf.render(
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
