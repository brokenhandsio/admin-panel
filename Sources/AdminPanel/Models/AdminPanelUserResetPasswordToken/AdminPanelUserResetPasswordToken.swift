import Fluent
import Vapor

public final class ResetPasswordToken: Model {
    public static let schema = "reset_password_tokens"

    @ID(custom: .id)
    public var id: Int?

    @Field(key: "token")
    var token: String
    
    @Field(key: "expiration")
    var expiration: Date

    @Parent(key: "user_id")
    var user: AdminPanelUser

    public init() {}

    public init(
        id: Int? = nil,
        token: String? = nil,
        expiration: Date,
        userId: AdminPanelUser.IDValue
    ) {
        self.id = id
        if let token {
            self.token = token
        } else {
            self.token = Self.generateTokenString()
        }
        self.expiration = expiration
        self.$user.id = userId
    }
    
    static func generateTokenString() -> String {
        Data([UInt8].random(count: 32)).base32EncodedString()
    }
}
