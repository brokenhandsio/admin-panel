import Foundation

extension AdminPanelUser {
    func generateResetPasswordToken(context: AdminPanelUser.ResetPasswordContext) throws -> ResetPasswordToken {
        let expiration = AdminPanelUser.ResetPasswordContext.expirationPeriod(
            for: .userRequestedToResetPassword
        )
        let token = ResetPasswordToken(
            expiration: Date().addingTimeInterval(expiration),
            userId: try self.requireID()
        )
        return token
    }

}
