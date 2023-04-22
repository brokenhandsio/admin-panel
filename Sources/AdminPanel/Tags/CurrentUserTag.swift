import Leaf

public struct CurrentUserTag: LeafTag {
    public func render(_ ctx: LeafContext) throws -> LeafData {
        guard let user = ctx.request?.auth.get(AdminPanelUser.self) else {
            return .trueNil
        }
        
        guard ctx.parameters.count > 0 else {
            return user.leafData
        }
        
        guard ctx.parameters.count == 1 else {
            throw "Invalid parameter count: \(ctx.parameters.count)/1"
        }
        
        guard
            let data = user.leafData.dictionary,
            let key = ctx.parameters[0].string,
            let value = data[key]
        else {
            throw "The key doesn't exist."
        }
        return value
    }
}
