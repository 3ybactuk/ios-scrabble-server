import Vapor
import JWT

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        
        auth.post("login", use: {try await self.login(req: $0)})
    }
    
    func login(req: Request) async throws -> String {
        let credentials = try req.content.decode(UserCredentials.self)
        let user = try await getUser(req: req)
        let token = try JWTUtil.createToken(from: user, signers: req.application.jwt.signers)
    }
    
    func getUser(req: Request) async throws -> User {
        let credentials = try req.content.decode(UserCredentials.self)
        
        guard let user = try await User.query(on: req.db)
            .filter
                .filter(\.$nickname == credentials.nickname)
                .first() else {
            throw Abort(.unauthorized)
        }
        
        if user.password == credentials.password {
            return user
        } else {
            throw Abort(.unauthorized)
        }
        
        return user
    }
    
    struct UserCredentials: Content {
        let nickname: String
        let password: String
    }
}


