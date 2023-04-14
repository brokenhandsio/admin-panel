import Leaf
import Vapor

public struct AdminPanelConfigTag: LeafTag {
    public func render(_ ctx: LeafContext) throws -> LeafData {
        try ctx.requireParameterCount(1)
        
        // We can throw this because the request should never be empty
        guard let request = ctx.request else {
            throw Abort(.internalServerError)
        }
        
        let user = request.auth.get(AdminPanelUser.self)
        let config = request.adminPanelConfigTagData
        
        return try config.viewData(
            for: ctx.parameters[0],
            user: user,
            ctx: ctx
        )
    }
}

public struct AdminPanelConfigTagData {
    enum Keys: String {
        case name
        case role
        case baseURL
        case sidebarMenuPath
        case dashboardPath
        case environment
    }

    public let name: String
    public let baseURL: String
    public let dashboardPath: String?
    public let sidebarMenuPathGenerator: SidebarMenuPathGenerator
    public let environment: Environment

    init(
        name: String,
        baseURL: String,
        sidebarMenuPathGenerator: @escaping SidebarMenuPathGenerator,
        dashboardPath: String? = nil,
        environment: Environment
    ) {
        self.name = name
        self.baseURL = baseURL
        self.sidebarMenuPathGenerator = sidebarMenuPathGenerator
        self.dashboardPath = dashboardPath
        self.environment = environment
    }

    func viewData(for data: LeafData, user: AdminPanelUser?, ctx: LeafContext) throws -> LeafData {
        guard let key = data.string else {
            throw "Wrong type given (expected a string): \(type(of: data))"
        }

        guard let parsedKey = Keys(rawValue: key) else {
            throw "Wrong argument given: \(key)"
        }

        switch parsedKey {
        case .name:
            return .string(name)
        case .role:
            return .string(user?.role?.rawValue ?? "")
        case .baseURL:
            return .string(baseURL)
        case .sidebarMenuPath:
            return user.map { .string(sidebarMenuPathGenerator($0.role)) } ?? .nil(.string)
        case .dashboardPath:
            return dashboardPath.map { .string($0) } ?? .nil(.string)
        case .environment:
            return .string(environment.name)
        }
    }
}

extension Request {
    var adminPanelConfigTagData: AdminPanelConfigTagData {
        return .init(
            name: self.adminPanel.config.name,
            baseURL: self.adminPanel.config.baseURL,
            sidebarMenuPathGenerator: self.adminPanel.config.sidebarMenuPathGenerator,
            environment: self.adminPanel.config.environment
        )
    }
}
