import Flash
import Vapor

public struct AdminPanelEndpoints {
    public let login: String
    public let logout: String
    public let dashboard: String
    public let adminPanelUserBasePath: String
    public let resetPassword: String
    public let resetPasswordSuccess: String

    public let createSlug: String
    public let deleteSlug: String
    public let editSlug: String
    public let meSlug: String

    public init(
        adminPanelUserBasePath: String = "/admin/users",
        dashboard: String = "/admin",
        login: String = "/admin/login",
        logout: String = "/admin/logout",
        resetPassword: String = "/admin/users/reset-password",
        resetPasswordSuccess: String = "/admin/users/reset-password/success",

        createSlug: String = "create",
        deleteSlug: String = "delete",
        editSlug: String = "edit",
        meSlug: String = "me"
    ) {
        self.login = login
        self.logout = logout
        self.dashboard = dashboard
        self.adminPanelUserBasePath = adminPanelUserBasePath
        self.resetPassword = resetPassword
        self.resetPasswordSuccess = resetPasswordSuccess

        self.createSlug = createSlug
        self.deleteSlug = deleteSlug
        self.editSlug = editSlug
        self.meSlug = meSlug
    }

    public static var `default`: AdminPanelEndpoints {
        return .init()
    }
}

func routes(_ app: Application) throws {
    let config: AdminPanelConfig = app.adminPanelConfig
    
    let loginController = config.controllers.loginController
    try app.register(collection: loginController)
    
    let dashboardController = config.controllers.dashboardController
    try app.register(collection: dashboardController)
    
    let adminPanelUserController = config.controllers.adminPanelUserController
    try app.register(collection: adminPanelUserController)
}
