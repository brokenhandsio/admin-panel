import Vapor
import Fluent

final class AdminPanelUserSeedCommand: AsyncCommand {
    private static var defaultEmail: String { return "admin@admin.com" }
    private static var defaultName: String { return "Test User" }
    
    struct Signature: CommandSignature {
        @Option(name: "email", short: "e", help: "The email of the user to seed.")
        var email: String?
        
        @Option(name: "password", short: "p", help: "The password of the user to seed.")
        var password: String
        
        @Option(name: "name", short: "n", help: "The name of the user to seed.")
        var name: String?
    }
    
    var help: String {
        "Seeds a test user with email 'admin@admin.com' and the supplied password."
    }
    
    func run(using context: CommandContext, signature: Signature) async throws {
        let password = signature.password
        let email = signature.email ?? SeedAdminPanelUserCommand.defaultEmail
        let name = signature.name ?? SeedAdminPanelUserCommand.defaultName
        
        let user = try AdminPanelUser(
            email: email,
            name: name,
            title: "Tester",
            role: .superAdmin,
            password: AdminPanelUser.hashPassword(password)
        )
        
        try await user.create(on: context.application.db)
    }
}
