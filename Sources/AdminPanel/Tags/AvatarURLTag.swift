import Leaf

public struct AvatarURLTag: LeafTag {
    public func render(_ ctx: LeafContext) throws -> LeafData {
        var identifier = ""
        var url: String?
        
        for index in 0...1 {
            if
                let param = ctx.parameters[index].string,
                !param.isEmpty
            {
                switch index {
                case 0: identifier = param
                case 1: url = param
                default: ()
                }
            }
        }
        
        let avatarURL = url ?? "https://api.adorable.io/avatars/150/\(identifier).png"
        return .string(avatarURL)
    }
}
