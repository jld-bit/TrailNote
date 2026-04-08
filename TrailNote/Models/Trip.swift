import Foundation
import SwiftData
import SwiftUI

@Model
final class Trip {
    var id: UUID
    var title: String
    var coverPhotoName: String
    var startDate: Date
    var endDate: Date
    var notes: String
    var colorHex: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \TripStop.trip)
    var stops: [TripStop] = []

    @Relationship(deleteRule: .cascade, inverse: \ChecklistItem.trip)
    var checklist: [ChecklistItem] = []

    init(
        id: UUID = UUID(),
        title: String,
        coverPhotoName: String,
        startDate: Date,
        endDate: Date,
        notes: String,
        colorHex: String = "#2E86DE",
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.coverPhotoName = coverPhotoName
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
        self.colorHex = colorHex
        self.createdAt = createdAt
    }

    var durationText: String {
        let days = Calendar.current.dateComponents([.day], from: startDate.startOfDay, to: endDate.startOfDay).day ?? 0
        if days <= 0 { return "1 day" }
        return "\(days + 1) days"
    }

    var sortedStops: [TripStop] {
        stops.sorted { $0.orderIndex < $1.orderIndex }
    }

    var sortedChecklist: [ChecklistItem] {
        checklist.sorted { $0.orderIndex < $1.orderIndex }
    }
}
