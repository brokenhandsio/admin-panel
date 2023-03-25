import Fluent
import Vapor

extension AdminPanelUserToken: ModelTokenAuthenticatable {
    typealias User = AdminPanelUser
    
    static let valueKey = \AdminPanelUserToken.$value
    static let userKey = \AdminPanelUserToken.$user
    
    var isValid: Bool {
        true
    }
}
