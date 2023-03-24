import Vapor
import Leaf

public protocol DashboardControllerType {
    func renderDashboard(_ req: Request) throws -> Future<Response>
}

public final class DashboardController: DashboardControllerType {
    public init() {}

    public func renderDashboard(_ req: Request) throws -> Future<Response> {
        let config = try req.make(AdminPanelConfig<U>.self)

        return try req
            .view()
            .render(config.views.dashboard.index, on: req)
            .encode(for: req)
    }
}
