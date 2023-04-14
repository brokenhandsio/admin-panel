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
        routes.get("request", use: requestPasswordResetHandler)
        routes.post("request", use: requestPasswordResetPostHandler)
        routes.get(use: resetPasswordHandler)
        routes.post(use: resetPasswordPostHandler)
    }
    
    func requestPasswordResetHandler(_ req: Request) async throws -> View {
        try await req.leaf.render(req.adminPanel.config.views.reset.requestResetPasswordForm)
    }
    
    func requestPasswordResetPostHandler(_ req: Request) async throws -> Response {
        // Fetch the user who wants to update their password
        let email = try req.content.get(String.self, at: "email")
        guard let user = try await AdminPanelUser.query(on: req.db)
            .filter(\.$email == email)
            .first()
        else {
            throw Abort(.notFound, reason: "The email address is not registered")
        }
        
        // Creates a token with an expiration to be sent in the reset password url
        let resetToken = try user.generateResetPasswordToken(context: .userRequestedToResetPassword)
        try await resetToken.save(on: req.db)
        
        // Creates the url the user has to visit to update the password
        let url = req.adminPanel.config.baseURL.appending(
            "\(req.adminPanel.config.endpoints.resetPassword)/\(resetToken)"
        )
        
        // Sends an email to the user containing the url
        _ = try await req.adminPanel.requestPasswordReset(
            for: user,
            url: url,
            token: resetToken,
            context: .userRequestedToResetPassword
        )
        
        return req.redirect(to: req.adminPanel.config.endpoints.login)
            .flash(.success, "Email with reset link sent")
    }
    
    func resetPasswordHandler(_ req: Request) async throws -> View {
        try await req.leaf.render(req.adminPanel.config.views.reset.resetPasswordForm)
    }
    
    func resetPasswordPostHandler(_ req: Request) async throws -> Response {
        let user = try req.auth.require(AdminPanelUser.self)
        let data = try req.content.decode(ResetPasswordData.self)
        guard data.password == data.passwordConfirmation else {
            return try await req.flash(.error, "The two passwords don't match")
                .leaf.render(req.adminPanel.config.views.reset.resetPasswordForm)
                .encodeResponse(for: req)
        }
        user.password = try Bcrypt.hash(data.password)
        try await user.save(on: req.db)
        return try await req
            .flash(.success, "Your password has been updated")
            .leaf.render(req.adminPanel.config.views.reset.resetPasswordSuccess)
            .encodeResponse(for: req)
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
