import Fluent

struct CreatePlayer: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("players")
            .id()
            .field("room_id", .uuid, .required)
            .field("user_id", .uuid, .required)
            .field("score", .int32, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("players").delete()
    }
}
