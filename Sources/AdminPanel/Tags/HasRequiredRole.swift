import Leaf

public struct HasRequiredRole: LeafTag {
    public func render(_ ctx: LeafContext) throws -> LeafData {
        try ctx.requireParameterCount(1)
        
        guard
            let roleString = ctx.parameters[0].string,
            let requiredRole = AdminPanelUser.Role(rawValue: roleString)
        else {
            throw "Invalid role requirement"
        }
        
        guard let userRole = ctx.request?.auth.get(AdminPanelUser.self)?.role else {
            return .bool(false)
        }
        
        return .bool(userRole >= requiredRole)
    }
}
