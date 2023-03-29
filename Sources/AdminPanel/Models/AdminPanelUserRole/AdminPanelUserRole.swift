import Fluent
import Vapor

public protocol RoleType: LosslessStringConvertible, Comparable, Codable {
    var menuPath: String { get }
}

extension AdminPanelUser {
    public enum Role: String {
        case superAdmin
        case admin
        case user

        public var weight: UInt {
            switch self {
            case .superAdmin: return 3
            case .admin: return 2
            case .user: return 1
            }
        }

        public typealias RawValue = String

        public init?(rawValue: String?) {
            switch rawValue {
            case Role.superAdmin.rawValue: self = .superAdmin
            case Role.admin.rawValue: self = .admin
            case Role.user.rawValue: self = .user
            default: return nil
            }
        }
    }
}


extension AdminPanelUser.Role: RoleType {
    public var menuPath: String {
        switch self {
        case .superAdmin:
            return "AdminPanel/Layout/Partials/Sidebars/superadmin"
        case .admin:
            return "AdminPanel/Layout/Partials/Sidebars/admin"
        case .user:
            return "AdminPanel/Layout/Partials/Sidebars/user"
        }
    }

    public init?(_ description: String) {
        guard let role = AdminPanelUser.Role(rawValue: description) else {
            return nil
        }

        self = role
    }

    public var description: String {
        return self.rawValue
    }

    public static func < (lhs: AdminPanelUser.Role, rhs: AdminPanelUser.Role) -> Bool {
        return lhs.weight < rhs.weight
    }

    public static func == (lhs: AdminPanelUser.Role, rhs: AdminPanelUser.Role) -> Bool {
        return lhs.weight == rhs.weight
    }
}

extension AdminPanelUser {
    func requireRole(role: AdminPanelUser.Role?) throws -> AdminPanelUser.Role {
        guard
            let selfRole = self.role,
            let role = role,
            selfRole >= role
        else {
            throw Abort(.unauthorized)
        }
        return role
    }
}

extension AdminPanelUser.Role: CaseIterable {}
extension AdminPanelUser.Role: Content {}
