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
    
    init() { }

    init(id: UUID? = nil, currentUses: Int32, maxUses: Int32) {
        self.id = id
        self.currentUses = currentUses
        self.maxUses = maxUses
    }
}
