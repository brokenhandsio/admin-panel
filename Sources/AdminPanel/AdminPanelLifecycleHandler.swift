import Bootstrap
import Flash
import Fluent
import JWT
import Leaf
import Submissions
import Vapor

public class AdminPanelLifecycleHandler: LifecycleHandler {
    var config: AdminPanelConfig
    
    public init(config: AdminPanelConfig) {
        self.config = config
    }
    
    public func willBoot(_ app: Application) throws {
        // MARK: Leaf
        app.views.use(.leaf)
        registerLeafTags(app)
        
        // MARK: Commands
//        app.commands.use(AdminPanelUserSeedCommand(), as: "adminpanel:user-seeder")
        
        // MARK: Middleware
        app.middleware.use(FlashMiddleware())
        app.middleware.use(ShouldResetPasswordMiddleware(
            path: "\(config.endpoints.adminPanelUserBasePath)/\(config.endpoints.meSlug)/\(config.endpoints.editSlug)"
        ))

        // MARK: Sessions
        app.sessions.use(.fluent)
        app.middleware.use(app.sessions.middleware)
        app.middleware.use(AdminPanelUser.asyncSessionAuthenticator())
        app.migrations.add(SessionRecord.migration)
        
        try registerRoutes(app)

    }
    
    func registerRoutes(_ app: Application) throws {
        let adminPanelRoutes = app.routes.grouped("admin")
        
        let loginController = LoginController()
        try adminPanelRoutes.register(collection: loginController)
        
        let sessionedRoutes = adminPanelRoutes.grouped(AdminPanelUser.asyncSessionAuthenticator())
        
        let dashboardController = DashboardController()
        try sessionedRoutes.register(collection: dashboardController)
        
        let usersSessionedRoutes = sessionedRoutes.grouped("users")
        
        let adminPanelUserController = AdminPanelUserController()
        try usersSessionedRoutes.register(collection: adminPanelUserController)
        
        let resetController = ResetController()
        try usersSessionedRoutes.register(collection: resetController)
    }
    
    func registerLeafTags(_ app: Application) {
        app.leaf.tags["adminPanel:flashes"] = FlashTag()
        app.leaf.tags["adminPanel:avatarURL"] = AvatarURLTag()
        app.leaf.tags["adminPanel:config"] = AdminPanelConfigTag()
        app.leaf.tags["adminPanel:user"] = CurrentUserTag()
        app.leaf.tags["adminPanel:hasRequiredRole"] = HasRequiredRole()
    }
}

//public extension LeafTagConfig {
//    mutating func useAdminPanelLeafTags<U: AdminPanelUserType>(
//        _ type: U.Type,
//        paths: TagTemplatePaths = .init()
//    ) {
//        useBootstrapLeafTags()
//        use([
//            "adminPanel:avatarURL": AvatarURLTag(),
//            "adminPanel:config": AdminPanelConfigTag<U>(),
//            "adminPanel:sidebar:heading": SidebarHeadingTag(),
//            "adminPanel:sidebar:menuItem": SidebarMenuItemTag(),
//            "adminPanel:user": CurrentUserTag<U>(),
//            "adminPanel:user:requireRole": RequireRoleTag<U>(),
//            "adminPanel:user:hasRequiredRole": HasRequiredRole<U>(),
//            "number": NumberFormatTag(),
//            "offsetPaginator": OffsetPaginatorTag(templatePath: "Paginator/offsetpaginator"),
//            "submissions:WYSIWYG": InputTag(templatePath: paths.wysiwygField)
//        ])
//    }
//}
