import LeafBootstrap
import Flash
import Fluent
import JWT
import Leaf
import LeafKit
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
        app.migrations.add(SessionRecord.migration)

        app.migrations.add(AdminPanelUser.CreateMigration())
        app.migrations.add(ResetPasswordToken.CreateMigration())
        app.migrations.add(SeedAdminPanelUser())
        
        try registerRoutes(app)
    }
    
    func registerRoutes(_ app: Application) throws {
        let adminPanelRoutes = app.routes.grouped("admin")
        let sessionedRoutes = adminPanelRoutes.grouped(
            AdminPanelUser.asyncSessionAuthenticator()
        )
        try sessionedRoutes.register(collection: LoginController())
        try sessionedRoutes.register(collection: DashboardController())
        
        let usersRoutes = sessionedRoutes.grouped("users")
        let resetPasswordRoutes = usersRoutes.grouped("reset-password")
        try resetPasswordRoutes.register(collection: ResetController())

        let protectedRoutes = usersRoutes.grouped(
            AdminPanelUser.redirectMiddleware(path: app.adminPanel.config.endpoints.login)
        )
        try protectedRoutes.register(collection: AdminPanelUserController())
    }
    
    func registerLeafTags(_ app: Application) {
        app.leaf.useBootstrapTags()
        app.leaf.tags["adminPanelFlashes"] = FlashTag()
        app.leaf.tags["adminPanelAvatarURL"] = AvatarURLTag()
        app.leaf.tags["adminPanelConfig"] = AdminPanelConfigTag()
        app.leaf.tags["adminPanelUser"] = CurrentUserTag()
        app.leaf.tags["adminPanelHasRequiredRole"] = HasRequiredRole()
        app.leaf.tags["adminPanelSidebarMenuItem"] = SidebarMenuItemTag()
        app.leaf.tags["adminPanelSidebarHeading"] = SidebarHeadingTag()
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
