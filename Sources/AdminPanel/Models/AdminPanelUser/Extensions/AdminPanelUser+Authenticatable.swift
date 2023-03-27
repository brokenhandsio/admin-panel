import Fluent
import Vapor

extension AdminPanelUser: ModelAuthenticatable {
    public static let usernameKey = \AdminPanelUser.$email
    public static let passwordHashKey = \AdminPanelUser.$password
    
    public func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension AdminPanelUser: ModelCredentialsAuthenticatable {}
extension AdminPanelUser: ModelSessionAuthenticatable {}
