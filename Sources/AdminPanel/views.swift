public struct AdminPanelViews {
    public static let prefix = "AdminPanel"

    public struct Login {
        public let index: String
        public let requestResetPassword: String
        public let resetPassword: String

        public init(
            index: String = prefix + "/Login/index",
            requestResetPassword: String = prefix + "/Login/request-reset-password",
            resetPassword: String = prefix + "/Login/reset-password"
        ) {
            self.index = index
            self.requestResetPassword = requestResetPassword
            self.resetPassword = resetPassword
        }
    }

    public struct Dashboard {
        public let index: String

        public init(index: String = prefix + "/Dashboard/index") {
            self.index = index
        }
    }

    public struct AdminPanelUser {
        public let index: String
        public let editAndCreate: String

        public init(
            index: String = prefix + "/AdminPanelUser/index",
            editAndCreate: String = prefix + "/AdminPanelUser/edit"
        ) {
            self.index = index
            self.editAndCreate = editAndCreate
        }
    }

    public struct Reset {
        public let requestResetPasswordEmail: String
        public let newUserResetPasswordEmail: String
        public let requestResetPasswordForm: String
        public let requestResetPasswordSuccess: String
        public let resetPasswordForm: String
        public let resetPasswordSuccess: String

        public init(
            requestResetPasswordEmail: String = prefix + "/Reset/request-reset-password-email",
            newUserResetPasswordEmail: String = prefix + "/Reset/new-user-reset-password-email",
            requestResetPasswordForm: String = prefix + "/Reset/reset-password-request-form",
            requestResetPasswordSuccess: String = prefix + "/Reset/reset-password-request-success",
            resetPasswordForm: String = prefix + "/Reset/reset-password-form",
            resetPasswordSuccess: String = prefix + "/Reset/reset-password-success"
        ) {
            self.requestResetPasswordEmail = requestResetPasswordEmail
            self.newUserResetPasswordEmail = newUserResetPasswordEmail
            self.requestResetPasswordForm = requestResetPasswordForm
            self.requestResetPasswordSuccess = requestResetPasswordSuccess
            self.resetPasswordForm = resetPasswordForm
            self.resetPasswordSuccess = resetPasswordSuccess
        }
    }

    public let login: Login
    public let dashboard: Dashboard
    public let adminPanelUser: AdminPanelUser
    public let reset: Reset

    public init(
        login: Login = Login(),
        dashboard: Dashboard = Dashboard(),
        adminPanelUser: AdminPanelUser = AdminPanelUser(),
        reset: Reset = Reset()
    ) {
        self.login = login
        self.dashboard = dashboard
        self.adminPanelUser = adminPanelUser
        self.reset = reset
    }

    public static var `default`: AdminPanelViews {
        return .init()
    }
}
