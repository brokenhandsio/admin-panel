import Fluent
import JWT
import Vapor

public struct AdminPanelConfig {
    public let name: String
    public let baseURL: String
    public let endpoints: Endpoints
    public let views: Views
    public let sidebarMenuPathGenerator: SidebarMenuPathGenerator
    public let resetPasswordEmail: ResetPasswordEmail
    public let specifyPasswordEmail: SpecifyPasswordEmail
    public let environment: Environment

    public init(
        name: String,
        baseURL: String,
        endpoints: Endpoints = .default,
        views: Views = .default,
        sidebarMenuPathGenerator: @escaping SidebarMenuPathGenerator = AdminPanelUser.Role.sidebarMenuPathGenerator,
        resetPasswordEmail: ResetPasswordEmail = .default,
        specifyPasswordEmail: SpecifyPasswordEmail = .default,
        environment: Environment
    ) {
        self.name = name
        self.baseURL = baseURL
        self.endpoints = endpoints
        self.views = views
        self.sidebarMenuPathGenerator = sidebarMenuPathGenerator
        self.resetPasswordEmail = resetPasswordEmail
        self.specifyPasswordEmail = specifyPasswordEmail
        self.environment = environment
    }
}

extension AdminPanelConfig {
    public struct ResetPasswordEmail {
        public let fromEmail: String
        public let subject: String

        public init(fromEmail: String, subject: String) {
            self.fromEmail = fromEmail
            self.subject = subject
        }

        public static var `default`: Self {
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

        public static var `default`: Self {
            return .init(
                fromEmail: "no-reply@myadminpanel.com",
                subject: "Specify Password"
            )
        }
    }
}
