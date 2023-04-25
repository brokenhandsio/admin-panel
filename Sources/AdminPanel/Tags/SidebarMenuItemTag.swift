import Leaf

public struct SidebarMenuItemTag: UnsafeUnescapedLeafTag {
    public func render(_ ctx: LeafContext) throws -> LeafData {
//        let body = try ctx.requireBody()
        
        var (url, icon) = try parseParameters(ctx)
        icon = "<span data-feather='\(icon ?? "")'></span>"
        
        var activeLink = ""
        var activeTitle = ""
        
        if ctx.parameters.count > 2 {
            let currentPath = ctx.request?.url.path ?? ""
            let activeURLPatterns = ctx.parameters.dropFirst(2)
            
            if isActive(currentPath: currentPath, pathPatterns: activeURLPatterns) {
                activeLink = " active"
                activeTitle = " <span class='sr-only'>(current)</span>"
            }
        }
        
        let body = try ctx.getRawTagBody()

        let item =
        """
        <li class="nav-item">
            <a class="nav-link\(activeLink)" href="\(url)">
                \(icon ?? "")
                \(body)\(activeTitle)
            </a>
        </li>
        """
        
        return .string(item)


    }
    
    private func parseParameters(_ ctx: LeafContext) throws -> (url: String, icon: String?) {
        let url = try ctx.parse(index: 0, type: "url")
        let icon = try ctx.parse(index: 1, type: "icon")
        
        return (url ?? "#", icon)
    }
}

private extension SidebarMenuItemTag {
    func isActive(currentPath: String, pathPatterns: ArraySlice<LeafData>) -> Bool {
        for arg in pathPatterns {
            let searchPath = arg.string ?? ""

            if
                searchPath.hasSuffix("*"),
                currentPath.contains(searchPath.replacingOccurrences(of: "*", with: ""))
            {
                return true
            }

            if searchPath == currentPath {
                return true
            }
        }

        return false
    }
}
