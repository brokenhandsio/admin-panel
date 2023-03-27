import Vapor
import Leaf

public protocol DashboardControllerType: RouteCollection {
    func dashboardHandler(_ req: Request) async throws -> View
}

public final class DashboardController: DashboardControllerType {
    public func boot(routes: RoutesBuilder) throws {
        let adminAuthSessionRoutes = routes
            .grouped(AdminPanelUser.sessionAuthenticator())
        adminAuthSessionRoutes.get("admin", use: dashboardHandler)
    }
    
    public func dashboardHandler(_ req: Request) async throws -> View {
        try await req.leaf.render(req.adminPanelConfig.views.dashboard.index)
    }
}
