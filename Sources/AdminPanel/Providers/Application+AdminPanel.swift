import Vapor

extension Application {
    public var adminPanelConfig: AdminPanelConfig {
        .init(self)
    }
}
