import Async
import Leaf
import Sugar
import TemplateKit

public final class AdminPanelConfigTag: TagRenderer {
    public func render(tag: TagContext) throws -> Future<TemplateData> {
        try tag.requireParameterCount(1)
        let request = try tag.requireRequest()
        let config = try request.privateContainer.make(AdminPanelConfigTagData.self)
        let container = try request.privateContainer.make(CurrentUserContainer.self)

        return try tag.future(
            config.viewData(
                for: tag.parameters[0],
                user: container.user,
                tag: tag
            )
        )
    }

    public init() {}
}

public final class AdminPanelConfigTagData {
    enum Keys: String {
        case name
        case baseURL
        case sidebarMenuPath
        case dashboardPath
        case environment
    }

    public let name: String
    public let baseURL: String
    public let dashboardPath: String?
    public let sidebarMenuPathGenerator: SidebarMenuPathGenerator<U.Role>
    public let environment: Environment

    init(
        name: String,
        baseURL: String,
        sidebarMenuPathGenerator: @escaping SidebarMenuPathGenerator<U.Role>,
        dashboardPath: String? = nil,
        environment: Environment
    ) {
        self.name = name
        self.baseURL = baseURL
        self.sidebarMenuPathGenerator = sidebarMenuPathGenerator
        self.dashboardPath = dashboardPath
        self.environment = environment
    }

    func viewData(for data: TemplateData, user: AdminPanelUser?, tag: TagContext) throws -> TemplateData {
        guard let key = data.string else {
            throw tag.error(reason: "Wrong type given (expected a string): \(type(of: data))")
        }

        guard let parsedKey = Keys(rawValue: key) else {
            throw tag.error(reason: "Wrong argument given: \(key)")
        }

        switch parsedKey {
        case .name:
            return .string(name)
        case .baseURL:
            return .string(baseURL)
        case .sidebarMenuPath:
            return user.map {
                .string(sidebarMenuPathGenerator($0.role))
            } ?? .null
        case .dashboardPath:
            return dashboardPath.map { .string($0) } ?? .null
        case .environment:
            return .string(environment.name)
        }
    }
}

extension Request {
    var adminPanelConfigTagData: AdminPanelConfigTagData {
        return .init(
            name: self.adminPanelConfig.name,
            baseURL: self.adminPanelConfig.baseURL,
            sidebarMenuPathGenerator: self.adminPanelConfig.sidebarMenuPathGenerator,
            environment: self.adminPanelConfig.environment
        )
    }
}
