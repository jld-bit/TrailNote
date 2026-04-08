import Foundation
import SwiftData

@Model
final class ChecklistItem {
    var id: UUID
    var title: String
    var isDone: Bool
    var orderIndex: Int
    var trip: Trip?

    init(id: UUID = UUID(), title: String, isDone: Bool = false, orderIndex: Int) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.orderIndex = orderIndex
    }
}
