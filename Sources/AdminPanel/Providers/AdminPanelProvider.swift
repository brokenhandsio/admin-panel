import Bootstrap
import Flash
import Fluent
import JWT
import Leaf
import Submissions
import Vapor

public struct AdminPanelProvider {
    let application: Application?
    
    init(_ app: Application) {
        self.application = app
    }
    
    public func configure(_ app: Application) throws {
        let config = app.adminPanel.config
        // MARK: Leaf
        app.views.use(.leaf)
        app.leaf.tags["flashes"] = FlashTag()
        
        // MARK: Commands
//        app.commands.use(AdminPanelUserSeedCommand(), as: "adminpanel:user-seeder")
        
        // MARK: Middleware
        app.middleware.use(FlashMiddleware())
//        app.middleware.use(RedirectMiddleware())
        app.middleware.use(ShouldResetPasswordMiddleware(
            path: "\(config.endpoints.adminPanelUserBasePath)/\(config.endpoints.meSlug)/\(config.endpoints.editSlug)")
        )
        app.middleware.use(app.sessions.middleware)
        app.middleware.use(AdminPanelUser.asyncSessionAuthenticator())
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
