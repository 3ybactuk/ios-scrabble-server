import Fluent
import Vapor

struct PlayerController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let players = routes.grouped("players")

        players.get(use: { try await self.index(req: $0) })
        players.post(use: { try await self.create(req: $0) })
        players.group(":playerID") { player in
        player.delete(use: { try await self.delete(req: $0) })
        players.post("validateWord", use: validateWord)

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

    func delete(req: Request) async throws -> HTTPStatus {
        guard let player = try await Player.find(req.parameters.get("playerID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await player.delete(on: req.db)
        return .noContent
    }
    
    func validateWord(req: Request) async throws -> Response {
        guard let wordData = try? req.content.decode([String: String].self),
              let word = wordData["word"] else {
            return Response(status: .badRequest, body: .init(string: "Invalid data"))
        }

        let encodedWord = word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = URI(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(encodedWord)")
        let response = try await req.client.get(url)

        var status = "Word does not exist"
        var responseStatus = HTTPStatus.notFound

        if response.status == .ok, let body = response.body {
            let bodyString = String(buffer: body)
            if bodyString.contains("\"word\":") {
                status = "Word exists"
                responseStatus = .ok
            }
        } else {
            req.logger.info("API Response: Word does not exist or API error occurred")
        }

        let responseBody = try JSONEncoder().encode(["status": status])
        return Response(status: responseStatus, body: .init(data: responseBody))
    }

}
