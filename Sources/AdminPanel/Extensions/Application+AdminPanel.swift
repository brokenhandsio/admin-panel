import Vapor

extension Application {
    public var adminPanel: AdminPanel {
        .init(app: self)
    }
    
    public struct AdminPanel {
        let app: Application
        
        init(app: Application) {
            self.app = app
        }
        
        public var config: AdminPanelConfig {
            get {
                guard let config = app.storage[ConfigKey.self] else {
                    fatalError("AdminPanel not configured. Use app.adminPanel.config = ...")
                }
                return config
            }
            nonmutating set {
                self.app.storage.set(ConfigKey.self, to: newValue)
                self.app.lifecycle.use(AdminPanelLifecycleHandler(config: newValue))
            }
        }
        
        private struct ConfigKey: StorageKey {
            typealias Value = AdminPanelConfig
        }
    }
}
