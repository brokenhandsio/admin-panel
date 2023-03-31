public typealias SidebarMenuPathGenerator = ((AdminPanelUser.Role?) -> String)

public extension RoleType {
    static var sidebarMenuPathGenerator: SidebarMenuPathGenerator {
        return { role in
            role?.menuPath ?? ""
        }
    }
}
