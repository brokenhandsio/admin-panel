import Vapor

extension Request {
    private struct AdminPanelKey: StorageKey {
        typealias Value = AdminPanelConfig
    }
    
    private func initialize() -> AdminPanelConfig {
        self.application.storage[AdminPanelKey.self] = AdminPanelConfig(request: self)
        return self.application.storage[AdminPanelKey.self]!
    }
    
    public var adminPanelConfig: AdminPanelConfig {
        self.application.storage[AdminPanelKey.self] ?? self.initialize()
    }
}
