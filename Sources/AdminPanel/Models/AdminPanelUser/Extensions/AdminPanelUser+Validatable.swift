import Vapor

extension AdminPanelUser.Create: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("name", as: String.self, is: .count(2...191))
        validations.add("role", as: AdminPanelUser.Role.self)
        validations.add("title", as: String.self, is: .count(...191))
        validations.add("password", as: String.self, is: .count(8...) && .strongPassword)
    }
}

extension AdminPanelUser.Update: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email, required: false)
        validations.add("name", as: String.self, is: .count(2...191), required: false)
        validations.add("role", as: AdminPanelUser.Role.self, required: false)
        validations.add("title", as: String.self, is: .count(...191), required: false)
        validations.add("password", as: String.self, is: .count(8...) && .strongPassword, required: false)
    }
}
