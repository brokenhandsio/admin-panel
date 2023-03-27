import Fluent
import JWT
import Vapor

public struct AdminPanelConfig {
    public struct ResetPasswordEmail {
        public let fromEmail: String
        public let subject: String

        public init(fromEmail: String, subject: String) {
            self.fromEmail = fromEmail
            self.subject = subject
        }

        public static var `default`: ResetPasswordEmail {
            return .init(
                fromEmail: "no-reply@myadminpanel.com",
                subject: "Reset Password"
            )
        }
    }

    public struct SpecifyPasswordEmail {
        public let fromEmail: String
        public let subject: String

        public init(fromEmail: String, subject: String) {
            self.fromEmail = fromEmail
            self.subject = subject
        }

        public static var `default`: SpecifyPasswordEmail {
            return .init(
                fromEmail: "no-reply@myadminpanel.com",
                subject: "Specify Password"
            )
        }
    }

    public let name: String
    public let baseURL: String
    public let endpoints: AdminPanelEndpoints
    public let views: AdminPanelViews
    public let controllers: AdminPanelControllers
    public let sidebarMenuPathGenerator: SidebarMenuPathGenerator
    public let resetEndpoints: ResetEndpoints
    public let resetPasswordEmail: ResetPasswordEmail
    public let resetSigner: JWTSigner
    public let specifyPasswordEmail: SpecifyPasswordEmail
    public let environment: Environment

    public init(
        name: String,
        baseURL: String,
        endpoints: AdminPanelEndpoints = .default,
        views: AdminPanelViews = .default,
        controllers: AdminPanelControllers = .default,
        sidebarMenuPathGenerator: @escaping SidebarMenuPathGenerator = AdminPanelUser.Role.sidebarMenuPathGenerator,
        resetEndpoints: ResetEndpoints = ResetEndpoints(
            renderResetPasswordRequest: "/admin/users/reset-password/request",
            resetPasswordRequest: "/admin/users/reset-password/request",
            renderResetPassword: "/admin/users/reset-password",
            resetPassword: "/admin/users/reset-password"
        ),
        resetPasswordEmail: ResetPasswordEmail = .default,
        resetSigner: JWTSigner,
        specifyPasswordEmail: SpecifyPasswordEmail = .default,
        environment: Environment
    ) {
        self.name = name
        self.baseURL = baseURL
        self.endpoints = endpoints
        self.views = views
        self.controllers = controllers
        self.sidebarMenuPathGenerator = sidebarMenuPathGenerator
        self.resetEndpoints = resetEndpoints
        self.resetPasswordEmail = resetPasswordEmail
        self.resetSigner = resetSigner
        self.specifyPasswordEmail = specifyPasswordEmail
        self.environment = environment
    }
}

public struct AdminPanelControllers {
    public let loginController: LoginControllerType
    public let dashboardController: DashboardControllerType
    public let adminPanelUserController: AdminPanelUserControllerType

    public init(
        loginController: LoginControllerType,
        dashboardController: DashboardControllerType,
        adminPanelUserController: AdminPanelUserControllerType
    ) {
        self.loginController = loginController
        self.dashboardController = dashboardController
        self.adminPanelUserController = adminPanelUserController
    }
}

extension AdminPanelControllers {
    public static var `default`: AdminPanelControllers {
        return .init(
            loginController: LoginController(),
            dashboardController: DashboardController(),
            adminPanelUserController: AdminPanelUserController()
        )
    }
}
