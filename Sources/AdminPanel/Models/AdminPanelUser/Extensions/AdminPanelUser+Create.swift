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
            password = String.randomAlphaNumericString(12)
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
    static func randomAlphaNumericString(_ length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""

        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)]
            randomString += String(newCharacter)
        }

        return randomString
    }
}
