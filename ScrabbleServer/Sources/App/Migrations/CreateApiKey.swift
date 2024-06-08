import Fluent

struct CreateApiKey: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("api_keys")
            .id()
            .field("current_uses", .int32, .required)
            .field("max_uses", .int32, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("api_keys").delete()
    }
}
