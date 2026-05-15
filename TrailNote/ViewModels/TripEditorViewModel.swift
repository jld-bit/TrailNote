import Foundation
import SwiftUI

@MainActor
final class TripEditorViewModel: ObservableObject {
    @Published var title = ""
    @Published var coverPhotoName = "airplane"
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var notes = ""
    @Published var selectedColor: Color = .orange

    let availableSymbols = ["airplane", "map.fill", "sun.max.fill", "mountain.2.fill", "ferry.fill", "car.fill"]

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && endDate >= startDate
    }

    func makeTrip() -> Trip {
        Trip(
            title: title,
            coverPhotoName: coverPhotoName,
            startDate: startDate,
            endDate: endDate,
            notes: notes,
            colorHex: selectedColor.toHex()
        )
    }
}
