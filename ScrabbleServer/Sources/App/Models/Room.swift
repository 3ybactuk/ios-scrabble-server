import Fluent
import Vapor

final class Room: Model, Content {
    static let schema = "rooms"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "admin_id")
    var adminId: UUID
    
    @Field(key: "join_code")
    var joinCode: String
    
    @Field(key: "status")
    var status: String
    
    init() { }

    init(id: UUID? = nil, name: String, adminId: UUID, joinCode: String, status: String) {
        self.id = id
        self.name = name
        self.adminId = adminId
        self.joinCode = joinCode
        self.status = status
    }
}
