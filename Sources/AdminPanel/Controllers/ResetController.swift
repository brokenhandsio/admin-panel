import Flash
import Fluent
import Leaf
import Mailgun
import Submissions
import Vapor

protocol ResetControllerType: RouteCollection {
    func requestPasswordResetHandler(_ req: Request) async throws -> View
    func requestPasswordResetPostHandler(_ req: Request) async throws -> Response
    func resetPasswordHandler(_ req: Request) async throws -> View
    func resetPasswordPostHandler(_ req: Request) async throws -> Response
}

final class ResetController: ResetControllerType {
    func boot(routes: RoutesBuilder) throws {
        let adminAuthSessionRoutes = routes
            .grouped(AdminPanelUser.sessionAuthenticator())
            .grouped("admin", "users", "reset-password")
        adminAuthSessionRoutes.get("request", use: requestPasswordResetHandler)
        adminAuthSessionRoutes.post("request", use: requestPasswordResetPostHandler)
        adminAuthSessionRoutes.get(use: resetPasswordHandler)
        adminAuthSessionRoutes.post(use: resetPasswordPostHandler)
        adminAuthSessionRoutes.get("success", use: resetPasswordSuccessHandler)
    }
    
    func requestPasswordResetHandler(_ req: Request) async throws -> View {
        try await req.leaf.render(req.adminPanelConfig.views.reset.requestResetPasswordForm)
    }
    
    func requestPasswordResetPostHandler(_ req: Request) async throws -> Response {
        // Fetch the user who wants to update their password
        let email = try req.content.get(String.self, at: "email")
        guard let user = try await AdminPanelUser.query(on: req.db)
            .filter(\.$email == email)
            .first()
        else {
            throw Abort(.notFound)
        }
        
        // Creates a token with an expiration to be sent in the reset password url
        let resetTokenString = ResetPasswordToken.generateTokenString()
        let expiration = AdminPanelUser.ResetPasswordContext.expirationPeriod(
            for: .userRequestedToResetPassword
        )
        let resetToken = ResetPasswordToken(
            token: resetTokenString,
            expiration: Date().addingTimeInterval(expiration), // Adds one hour
            userId: try user.requireID()
        )
        try await resetToken.save(on: req.db)
        
        // Creates the url the user has to visit to update the password
        let url = req.adminPanelConfig.baseURL.appending(
            "\(req.adminPanelConfig.endpoints.resetPassword)/\(resetToken)"
        )
        
        // Sents an email to the user containing the url
        return try await req.requestPasswordReset(
            for: user,
            url: url,
            token: resetToken,
            context: .userRequestedToResetPassword
        )
    }
    
    func resetPasswordHandler(_ req: Request) async throws -> View {
        try await req.leaf.render(req.adminPanelConfig.views.reset.resetPasswordForm)
    }
    
    func resetPasswordPostHandler(_ req: Request) async throws -> Response {
        let user = try req.auth.require(AdminPanelUser.self)
        let data = try req.content.decode(ResetPasswordData.self)
        guard data.password == data.passwordConfirmation else {
            return try await req.flash(.error, "The two passwords don't match")
                .leaf.render(req.adminPanelConfig.views.reset.resetPasswordForm)
                .encodeResponse(for: req)
        }
        user.password = try Bcrypt.hash(data.password)
        try await user.save(on: req.db)
        return req.redirect(to: req.adminPanelConfig.endpoints.resetPasswordSuccess)
    }
    
    func resetPasswordSuccessHandler(_ req: Request) async throws -> View {
        try await req.leaf.render(req.adminPanelConfig.views.reset.resetPasswordSuccess)
    }
}

fileprivate struct ResetPasswordEmail: Codable {
    let url: String
    let expire: Int
}

fileprivate struct ResetPasswordData: Codable {
    let password: String
    let passwordConfirmation: String
}
