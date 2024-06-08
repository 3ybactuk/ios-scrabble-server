import Fluent
import Vapor

final class ApiKey: Model, Content {
    static let schema = "api_keys"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "current_uses")
    var currentUses: Int32
    
    @Field(key: "max_uses")
    var maxUses: Int32
    
    @Field(key: "api_role")
    var role: String
    
    init() { }

    init(id: UUID? = nil, currentUses: Int32, maxUses: Int32, role: String) {
        self.id = id
        self.currentUses = currentUses
        self.maxUses = maxUses
        self.role = role
    }
}
