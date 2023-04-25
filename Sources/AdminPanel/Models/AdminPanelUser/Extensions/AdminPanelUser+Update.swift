import Vapor

extension AdminPanelUser {
    public struct Update: Content {
        let email: String?
        let name: String?
        let title: String?
        let role: String?
        let password: String?
        let shouldResetPassword: Bool?
    }
    
    public func update(with update: Update) throws {
        if let email = update.email {
            self.email = email
        }
        if let name = update.name {
            self.name = name
        }
        if let password = update.password {
            self.password = try Bcrypt.hash(password)
        }
        if let shouldResetPassword = update.shouldResetPassword {
            self.shouldResetPassword = shouldResetPassword
        }
        self.title = update.title
        self.role = AdminPanelUser.Role(rawValue: update.role)
    }
}
