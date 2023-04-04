import Vapor
import Fluent

final class AdminPanelUserSeedCommand: AsyncCommand {
    private static var defaultEmail: String { return "admin@admin.com" }
    private static var defaultName: String { return "Test User" }
    
    struct Signature: CommandSignature {
        @Option(name: "email", short: "e", help: "The email of the user to seed.")
        var email: String?
        
        @Option(name: "password", short: "p", help: "The password of the user to seed.")
        var password: String?
        
        @Option(name: "name", short: "n", help: "The name of the user to seed.")
        var name: String?
    }
    
    var help: String {
        "Seeds a test user with email 'admin@admin.com' and the supplied password."
    }
    
    func run(using context: CommandContext, signature: Signature) async throws {
        guard let password = signature.password else {
            throw Abort(.internalServerError, reason: "Missing password argument")
        }
        
        let email = signature.email ?? AdminPanelUserSeedCommand.defaultEmail
        let name = signature.name ?? AdminPanelUserSeedCommand.defaultName
        
        let user = try AdminPanelUser(
            email: email,
            name: name,
            title: "Tester",
            role: .superAdmin,
            password: Bcrypt.hash(password)
        )
        
        try await user.create(on: context.application.db)
    }
}
