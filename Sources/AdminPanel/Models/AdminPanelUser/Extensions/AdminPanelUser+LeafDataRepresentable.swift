import LeafKit

extension AdminPanelUser: LeafDataRepresentable {
    public var leafData: LeafData {
        .dictionary([
            "id": .int(id),
            "email": .string(email),
            "name": .string(name),
            "title": title.map { .string($0) } ?? .nil(.string),
            "avatarURL": avatarURL.map { .string($0) } ?? .nil(.string),
            "role": role.map { .string($0.description) } ?? .nil(.string)
        ])
    }
}
