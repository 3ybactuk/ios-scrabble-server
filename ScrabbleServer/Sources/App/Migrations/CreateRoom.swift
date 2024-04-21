import Fluent

struct CreateRoom: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("rooms")
            .id()
            .field("name", .string, .required)
            .field("admin_id", .uuid, .required)
            .field("join_code", .string, .required)
            .field("status", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("rooms").delete()
    }
}
