import Authentication
import Bootstrap
import Flash
import Fluent
import JWT
import Leaf
import Paginator
import Reset
import Submissions
import Sugar
import Vapor

public struct AdminPanelProvider {
    let application: Application?
    
    init(_ app: Application) {
        self.application = app
    }

    /// See Service.Provider.repositoryName
    public static var repositoryName: String { return "admin-panel" }
    
    public func configure(_ app: Application) throws {
        // MARK: Leaf
        app.views.use(.leaf)
        app.leaf.tags["flashes"] = FlashTag()
        
        // MARK: Commands
        app.commands.use(AdminPanelUserSeedCommand(), as: "adminpanel:user-seeder")
        
        // MARK: Middleware
        app.middleware.use(FlashMiddleware())
        app.middleware.use(RedirectMiddleware())
        app.middleware.use(ShouldResetPasswordMiddleware())
    }

    /// See Service.Provider.boot
    public func didBoot(_ container: Container) throws -> Future<Void> {
        return .done(on: container)
    }
}

//extension ResetResponses {
//    static func adminPanel<U: AdminPanelUserType>(config: AdminPanelConfig<U>) -> ResetResponses {
//        return ResetResponses(
//            resetPasswordRequestForm: { [config] req in
//                try req
//                    .view()
//                    .render(config.views.login.requestResetPassword, on: req)
//                    .encode(for: req)
//            },
//            resetPasswordUserNotified: { [config] req in
//                req.future(req
//                    .redirect(to: config.endpoints.login)
//                    .flash(.success, "Email with reset link sent.")
//                )
//            },
//            resetPasswordForm: { [config] req, _ in
//                try req.addFields(forType: U.self)
//                return try req
//                    .view()
//                    .render(config.views.login.resetPassword, on: req)
//                    .encode(for: req)
//            },
//            resetPasswordSuccess: { [config] req, _ in
//                req.future(req
//                    // TODO: make configurable
//                    .redirect(to: config.endpoints.login)
//                    .flash(.success, "Your password has been updated.")
//                )
//            }
//        )
//    }
//}

public extension LeafTagConfig {
    mutating func useAdminPanelLeafTags<U: AdminPanelUserType>(
        _ type: U.Type,
        paths: TagTemplatePaths = .init()
    ) {
        useBootstrapLeafTags()
        use([
            "adminPanel:avatarURL": AvatarURLTag(),
            "adminPanel:config": AdminPanelConfigTag<U>(),
            "adminPanel:sidebar:heading": SidebarHeadingTag(),
            "adminPanel:sidebar:menuItem": SidebarMenuItemTag(),
            "adminPanel:user": CurrentUserTag<U>(),
            "adminPanel:user:requireRole": RequireRoleTag<U>(),
            "adminPanel:user:hasRequiredRole": HasRequiredRole<U>(),
            "number": NumberFormatTag(),
            "offsetPaginator": OffsetPaginatorTag(templatePath: "Paginator/offsetpaginator"),
            "submissions:WYSIWYG": InputTag(templatePath: paths.wysiwygField)
        ])
    }
}
