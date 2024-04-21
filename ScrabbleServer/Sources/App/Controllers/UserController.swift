import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")

        users.get(use: { try await self.index(req: $0) })
        users.post(use: { try await self.create(req: $0) })
        users.group(":userID") { user in
            user.delete(use: { try await self.delete(req: $0) })
        }
    }

    func index(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }

    func create(req: Request) async throws -> User {
        let user = try req.content.decode(User.self)

        try await user.save(on: req.db)
        return user
    }
    
    func update(req: Request) async throws -> User {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedUser = try req.content.decode(User.self)
        
        user.nickname = updatedUser.nickname
        user.password = updatedUser.password
        
        try await updatedUser.update(on: req.db)
        return updatedUser
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await user.delete(on: req.db)
        return .noContent
    }
}
