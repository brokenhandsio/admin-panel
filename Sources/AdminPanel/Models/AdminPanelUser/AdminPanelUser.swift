import Fluent
import Vapor

public final class AdminPanelUser: Model {
    @ID(custom: .id)
    public var id: Int?

    @Field(key: "email")
    public var email: String

    @Field(key: "name")
    public var name: String

    @Field(key: "title")
    public var title: String?

    @Field(key: "avatarUrl")
    public var avatarURL: String?

    @Field(key: "role")
    public var role: AdminPanelUserRole?

    @Field(key: "password")
    public var password: String

    @Field(key: "passwordChangeCount")
    public var passwordChangeCount: Int

    @Field(key: "shouldResetPassword")
    public var shouldResetPassword: Bool

    @Timestamp(key: "createdAt", on: .create)
    public var createdAt: Date?

    @Timestamp(key: "deletedAt", on: .delete)
    public var deletedAt: Date?

    @Timestamp(key: "updatedAt", on: .update)
    public var updatedAt: Date?

    public init() { }

    public init(
        id: Int? = nil,
        email: String,
        name: String,
        title: String? = nil,
        avatarURL: String? = nil,
        role: AdminPanelUserRole?,
        password: String,
        passwordChangeCount: Int = 0,
        shouldResetPassword: Bool = false
    ) throws {
        self.id = id
        self.email = email
        self.name = name
        self.title = title
        self.avatarURL = avatarURL
        self.role = role
        self.password = password
        self.passwordChangeCount = passwordChangeCount
        self.shouldResetPassword = shouldResetPassword
    }
}

extension AdminPanelUser: Content {}
