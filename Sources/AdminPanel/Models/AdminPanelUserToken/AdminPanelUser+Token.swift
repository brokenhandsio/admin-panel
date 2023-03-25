extension AdminPanelUser {
    func generateToken() throws -> AdminPanelUserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}
