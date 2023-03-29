import Fluent
import Vapor

public final class AdminPanelUser: Model {
    public static var schema: String = "admin_panel_users"
    
    @ID(custom: .id)
    public var id: Int?

    @Field(key: "email")
    public var email: String

    @Field(key: "name")
    public var name: String

    @Field(key: "title")
    public var title: String?

    @Field(key: "avatar_url")
    public var avatarURL: String?

    @Field(key: "role")
    public var role: AdminPanelUser.Role?

    @Field(key: "password")
    public var password: String

    @Field(key: "password_change_count")
    public var passwordChangeCount: Int

    @Field(key: "should_reset_password")
    public var shouldResetPassword: Bool

    @Timestamp(key: "created_at", on: .create)
    public var createdAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    public var deletedAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    public var updatedAt: Date?

    public init() { }

    public init(
        id: Int? = nil,
        email: String,
        name: String,
        title: String? = nil,
        avatarURL: String? = nil,
        role: AdminPanelUser.Role?,
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
