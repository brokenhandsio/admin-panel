import Vapor

extension Request {
    public var adminPanel: AdminPanel {
        .init(request: self)
    }
    
    public struct AdminPanel {
        let request: Request
        
        var config: AdminPanelConfig {
            request.application.adminPanel.config
        }
    }
}
