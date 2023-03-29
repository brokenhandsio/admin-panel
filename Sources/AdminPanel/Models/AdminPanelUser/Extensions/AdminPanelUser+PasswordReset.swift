import Mailgun
import Submissions
import Vapor

extension AdminPanelUser {
    public enum ResetPasswordContext {
        case userRequestedToResetPassword
        case newUserWithoutPassword
        
        public static func expirationPeriod(
            for context: ResetPasswordContext
        ) -> TimeInterval {
            switch context {
            case .userRequestedToResetPassword: return 60 * 60
            case .newUserWithoutPassword: return 3 * 24 * 60 * 60
            }
        }
    }
}

extension Request {
    public func requestPasswordReset(
        for user: AdminPanelUser,
        url: String,
        token: ResetPasswordToken,
        context: AdminPanelUser.ResetPasswordContext
    ) async throws -> Response {
        let config = self.adminPanelConfig
        var from: String
        var subject: String
        var view: String
        
        switch context {
        case .userRequestedToResetPassword:
            from = config.resetPasswordEmail.fromEmail
            subject = config.resetPasswordEmail.subject
            view = config.views.reset.requestResetPasswordEmail
        case .newUserWithoutPassword:
            from = config.specifyPasswordEmail.fromEmail
            subject = config.specifyPasswordEmail.subject
            view = config.views.reset.newUserResetPasswordEmail
        }
        
        let expiration = (Int(token.expiration.timeIntervalSinceNow) / 60 ) % 60
        let emailData = ResetPasswordEmail(url: url, expire: expiration)
        
        let html: View = try await self.leaf.render(view, emailData)
        let htmlString = String(buffer: html.data)
        
        let message = MailgunMessage(
            from: from,
            to: user.email,
            subject: subject,
            text: "Please turn on html to view this email.",
            html: htmlString
        )
        return try await self.mailgun().send(message)
            .encodeResponse(for: self).get()
    }
}

fileprivate struct ResetPasswordEmail: Codable {
    let url: String
    let expire: Int
}
