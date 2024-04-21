import Fluent
import Vapor

final class Player: Model, Content {
    static let schema = "players"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "room_id")
    var roomId: UUID
    
    @Field(key: "user_id")
    var userId: UUID
    
    @Field(key: "score")
    var score: Int32
    
    init() { }

    init(id: UUID? = nil, roomId: UUID, userId: UUID, score: Int32) {
        self.id = id
        self.roomId = roomId
        self.userId = userId
        self.score = score
    }
}
