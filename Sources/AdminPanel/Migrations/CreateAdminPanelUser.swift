import Vapor
import Fluent
import FluentSQL

public extension AdminPanelUser {
    struct CreateMigration: AsyncMigration {
        public func prepare(on database: Database) async throws {
            var roleTypeEnumBuilder = database.enum(AdminPanelUser.Role.schema)
            for role in AdminPanelUser.Role.allCases {
                roleTypeEnumBuilder = roleTypeEnumBuilder.case(role.rawValue)
            }
            let roles = try await roleTypeEnumBuilder.create()
            try await database.schema(AdminPanelUser.schema)
                .field("id", .int, .identifier(auto: true))
                .field("email", .string, .required)
                .field("name", .string, .required)
                .field("title", .string)
                .field("avatar_url", .string)
                .field("should_reset_password", .bool, .sql(.default(false)))
                .field("password_change_count", .int, .sql(.default(1)))
                .field("password", .string, .required)
                .field("role", roles, .required)
                .field("created_at", .datetime, .required)
                .field("updated_at", .datetime, .required)
                .field("deleted_at", .datetime)
                .unique(on: "email")
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(AdminPanelUser.schema).delete()
            try await database.schema(AdminPanelUser.Role.schema).delete()
        }
    }
}
