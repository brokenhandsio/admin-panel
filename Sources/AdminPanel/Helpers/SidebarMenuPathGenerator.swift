public typealias SidebarMenuPathGenerator = ((AdminPanelUserRole?) -> String)

public extension AdminPanelUserRoleType {
    static var sidebarMenuPathGenerator: SidebarMenuPathGenerator {
        return { role in
            role?.menuPath ?? ""
        }
    }
}
