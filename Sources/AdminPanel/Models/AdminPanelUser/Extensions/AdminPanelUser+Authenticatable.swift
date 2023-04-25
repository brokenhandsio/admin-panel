import Fluent
import Vapor

extension AdminPanelUser {
    struct CredentialsAuthenticatior: AsyncCredentialsAuthenticator {
        typealias Credentials = LoginData
        
        func authenticate(credentials: Credentials, for request: Request) async throws {
            if let user = try await AdminPanelUser.query(on: request.db).filter(\.$email == credentials.email).first() {
                guard try Bcrypt.verify(credentials.password, created: user.password) else {
                    return
                }
                request.auth.login(user)
            }
        }
    }
}

extension AdminPanelUser: ModelSessionAuthenticatable {}

struct LoginData: Content {
    let email: String
    let password: String
}
