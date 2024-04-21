import Fluent
import Vapor

struct ApiKeyController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let apiKeys = routes.grouped("api_keys")

        apiKeys.get(use: { try await self.index(req: $0) })
        apiKeys.post(use: { try await self.create(req: $0) })
        apiKeys.group(":apiKeyID") { apiKey in
            apiKey.delete(use: { try await self.delete(req: $0) })
        }
    }

    func index(req: Request) async throws -> [ApiKey] {
        try await ApiKey.query(on: req.db).all()
    }

    func create(req: Request) async throws -> ApiKey {
        let apiKey = try req.content.decode(ApiKey.self)

        try await apiKey.save(on: req.db)
        return apiKey
    }
    
    func incrementUsage(req: Request) async throws -> ApiKey {
        guard let apiKey = try await ApiKey.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        apiKey.currentUses += 1
        try await apiKey.update(on: req.db)
        return apiKey
    }
    
    func update(req: Request) async throws -> ApiKey {
        guard let apiKey = try await ApiKey.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedApiKey = try req.content.decode(ApiKey.self)
        apiKey.currentUses = updatedApiKey.currentUses
        apiKey.maxUses = updatedApiKey.maxUses
        apiKey.role = updatedApiKey.role
        try await updatedApiKey.update(on: req.db)
        return updatedApiKey
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let apiKey = try await ApiKey.find(req.parameters.get("apiKeyID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await apiKey.delete(on: req.db)
        return .noContent
    }
}
