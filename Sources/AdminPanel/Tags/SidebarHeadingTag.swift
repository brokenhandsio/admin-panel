import Leaf

public struct SidebarHeadingTag: UnsafeUnescapedLeafTag {
    public func render(_ ctx: LeafContext) throws -> LeafData {
        // let body = ctx.requireBody()
        
        let body = try ctx.getRawTagBody()

        let classes = "sidebar-heading d-flex justify-content-between " +
                "align-items-center px-3 mt-4 mb-1 text-muted"
        let item =
        """
            <h6 class="\(classes)">
                <span>\(body)</span>
            </h6>
        """
        
        return .string(item)
    }
}
