import Vapor

extension AdminPanelUser {
    public struct Create: Content {
        let email: String
        let name: String
        let title: String?
        let role: String?
        let password: String
        let shouldResetPassword: Bool?
        let shouldSpecifyPassword: Bool?
    }

    public convenience init(_ create: Create) throws {
        let password: String
        if create.shouldSpecifyPassword == true {
            password = create.password
        } else {
            password = String.randomSecurePassword()
        }

        try self.init(
            email: create.email,
            name: create.name,
            title: create.title,
            role: AdminPanelUser.Role(rawValue: create.role),
            password: Bcrypt.hash(password),
            shouldResetPassword: create.shouldResetPassword ?? false
        )
    }
}

extension String {
    static func randomSecurePassword() -> String {
        let length = Int.random(in: 8...20)
        let uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
        let digits = "0123456789"
        let specials = "!@#$%^&*()_+-="
        var requiredChars = [Character]()
        var remainingLength = length
        
        // Ensure at least 1 uppercase letter
        requiredChars.append(uppercaseLetters.randomElement()!)
        remainingLength -= 1
        
        // Ensure at least 1 lowercase letter
        requiredChars.append(lowercaseLetters.randomElement()!)
        remainingLength -= 1
        
        // Ensure at least 1 digit or special character
        let digitOrSpecial = (Bool.random() ? digits : specials)
        requiredChars.append(digitOrSpecial.randomElement()!)
        remainingLength -= 1
        
        // Fill remaining characters with any of the above
        let allChars = uppercaseLetters + lowercaseLetters + digits + specials
        let remainingChars = (0..<remainingLength).map { _ in allChars.randomElement()! }
        
        let password = (requiredChars + remainingChars).shuffled()
        return String(password)
    }
}
