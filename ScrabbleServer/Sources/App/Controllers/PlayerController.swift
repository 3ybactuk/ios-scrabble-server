import Fluent
import Vapor

struct PlayerController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let players = routes.grouped("players")

        players.get(use: { try await self.index(req: $0) })
        players.post("add_to_room", use: { try await self.addToRoom(req: $0)})
        players.post(use: { try await self.create(req: $0) })
        players.group(":playerID") { player in
            player.delete(use: { try await self.delete(req: $0) })
        }
    }

    func index(req: Request) async throws -> [Player] {
        try await Player.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Player {
        let player = try req.content.decode(Player.self)

        try await player.save(on: req.db)
        return player
    }
    
    func addToRoom(req: Request) async throws -> HTTPStatus {
        return .ok
    }
    
    func update(req: Request) async throws -> Player {
        guard let player = try await Player.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedPlayer = try req.content.decode(Player.self)
        
        player.roomId = updatedPlayer.roomId
        player.score = updatedPlayer.score
        
        try await updatedPlayer.update(on: req.db)
        return updatedPlayer
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let player = try await Player.find(req.parameters.get("playerID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await player.delete(on: req.db)
        return .noContent
    }
}
