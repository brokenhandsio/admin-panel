import Vapor

func routes(_ app: Application) throws {
    let loginController = LoginController()
    try app.register(collection: loginController)
    
    let dashboardController = DashboardController()
    try app.register(collection: dashboardController)
    
    let adminPanelUserController = AdminPanelUserController()
    try app.register(collection: adminPanelUserController)
    
    let resetController = ResetController()
    try app.register(collection: resetController)
}
