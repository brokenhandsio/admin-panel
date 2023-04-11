import Vapor
import Fluent
import FluentSQL

public struct CreateAdminPanelUser: AsyncMigration {
    public func prepare(on database: Database) async throws {
        try await database.schema(AdminPanelUser.schema)
            .id()
            .field("email", .string, .required)
            .field("name", .string, .required)
            .field("title", .string)
            .field("avatar_url", .string)
            .field("should_reset_password", .bool, .sql(.default(false)))
            .field("password_change_count", .int, .sql(.default(1)))
            .field("password", .string, .required)
            .field("role", .string, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .field("deleted_at", .datetime)
            .unique(on: "email")
            .create()
    }

    public func revert(on database: Database) async throws {
        try await database.schema(AdminPanelUser.schema).delete()
    }
}
