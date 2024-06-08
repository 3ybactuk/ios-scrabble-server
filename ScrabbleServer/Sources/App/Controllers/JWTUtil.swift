import Foundation
import JWT

class JWTUtil {
    static func createToken(from user: User, signers: JWTSigners) throws -> String {
        do {
            let expiry = ExpirationClaim(value: Date().addingTimeInterval(3600))
            let payload = UserPayload(userID: user.id!.uuidString, exp: expiry)
            return try signers.sign(payload)
        } catch {
            throw JWTError.generic(identifier: "createToken", reason: "Can't create token")
        }
    }
    
    static func verifyToken(from tokenString: String, signers: JWTSigners) throws -> UserPayload {
        do {
            return try signers.verify(tokenString, as: UserPayload.self)
        } catch {
            throw JWTError.generic(identifier: "verifyToken", reason: "Can't verify token")
        }
    }
    
    struct UserPayload: JWTPayload {
        var userID: String
        var exp: ExpirationClaim
        
        func verify(using signer: JWTSigner) throws {
            try exp.verifyNotExpired()
        }
    }
}
