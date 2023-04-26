import Fluent

public extension ResetPasswordToken {
    public struct CreateMigration: AsyncMigration {
        public init() {}
        
        public func prepare(on database: Database) async throws {
            try await database.schema(ResetPasswordToken.schema)
                .field("id", .int, .identifier(auto: true))
                .field("token", .string, .required)
                .field("expiration", .date, .required)
                .field("user_id", .int, .required, .references(AdminPanelUser.schema, "id"))
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(ResetPasswordToken.schema).delete()
        }
    }
}
