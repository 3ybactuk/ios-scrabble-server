import Fluent
import Vapor

struct RoomController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let rooms = routes.grouped("rooms")

        rooms.get(use: { try await self.index(req: $0) })
        rooms.post(use: { try await self.create(req: $0) })
        rooms.group(":roomID") { room in
            room.delete(use: { try await self.delete(req: $0) })
        }
    }

    func index(req: Request) async throws -> [Room] {
        try await Room.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Room {
        let room = try req.content.decode(Room.self)
        
        try await room.save(on: req.db)
        return room
    }
    
    func update(req: Request) async throws -> Room {
        guard let room = try await Room.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedRoom = try req.content.decode(Room.self)
        
        room.name = updatedRoom.name
        room.adminId = updatedRoom.adminId
        room.joinCode = updatedRoom.joinCode
        room.status = updatedRoom.status
        
        try await updatedRoom.update(on: req.db)
        return updatedRoom
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let room = try await Room.find(req.parameters.get("roomID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await room.delete(on: req.db)
        return .noContent
    }
}
