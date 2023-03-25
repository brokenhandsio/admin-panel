import Fluent
import Vapor

final class AdminPanelUserToken: Model, Content {
    static let schema = "admin_panel_user_tokens"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String

    @Parent(key: "admin_panel_user_id")
    var user: AdminPanelUser
    
    init() { }
    
    init(
        id: UUID? = nil,
        value: String,
        userID: AdminPanelUser.IDValue
    ) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}
