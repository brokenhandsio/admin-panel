import Leaf

public final class SidebarHeadingTag: TagRenderer {
    public func render(tag: TagContext) throws -> Future<TemplateData> {
        let body = try tag.requireBody()

        return tag.serializer.serialize(ast: body).map(to: TemplateData.self) { body in
            let parsedBody = String(data: body.data, encoding: .utf8) ?? ""

            let classes = "sidebar-heading d-flex justify-content-between " +
                "align-items-center px-3 mt-4 mb-1 text-muted"
            let item =
            """
            <h6 class="\(classes)">
                <span>\(parsedBody)</span>
            </h6>
            """

            return .string(item)
        }
    }
}
