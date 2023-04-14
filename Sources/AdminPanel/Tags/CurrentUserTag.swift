import Leaf

public struct CurrentUserTag: LeafTag {
    public func render(_ ctx: LeafContext) throws -> LeafData {
        try ctx.requireParameterCount(1)

        guard let user = ctx.request?.auth.get(AdminPanelUser.self) else {
            throw "No user is logged in."
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
