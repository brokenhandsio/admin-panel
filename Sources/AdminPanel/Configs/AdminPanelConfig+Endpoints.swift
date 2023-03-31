extension AdminPanelConfig {
    public struct Endpoints {
        public let login: String
        public let logout: String
        public let dashboard: String
        public let adminPanelUserBasePath: String
        public let resetPassword: String
        public let resetPasswordRequest: String

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
            resetPasswordRequest: String = "/admin/users/reset-password/request",

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
            self.resetPasswordRequest = resetPasswordRequest

            self.createSlug = createSlug
            self.deleteSlug = deleteSlug
            self.editSlug = editSlug
            self.meSlug = meSlug
        }

        public static var `default`: Self {
            return .init()
        }
    }
}
