import Vapor
import Leaf

public protocol DashboardControllerType: RouteCollection {
    func dashboardHandler(_ req: Request) async throws -> View
}

public final class DashboardController: DashboardControllerType {
    public func boot(routes: RoutesBuilder) throws {
        routes.get(use: dashboardHandler)
        routes.get("dashboard", use: dashboardHandler)
    }
    
    public func dashboardHandler(_ req: Request) async throws -> View {
        try await req.leaf.render(req.adminPanel.config.views.dashboard.index)
    }
}
