import Foundation
import MapKit

@MainActor
final class TripDetailViewModel: ObservableObject {
    @Published var newChecklistTitle = ""

    func moveStops(in trip: Trip, from source: IndexSet, to destination: Int) {
        var stops = trip.sortedStops
        stops.move(fromOffsets: source, toOffset: destination)
        for (index, stop) in stops.enumerated() {
            stop.orderIndex = index
        }
    }

    func addChecklistItem(to trip: Trip) {
        let value = newChecklistTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { return }
        let item = ChecklistItem(title: value, orderIndex: trip.checklist.count)
        item.trip = trip
        trip.checklist.append(item)
        newChecklistTitle = ""
    }

    func toggleChecklist(_ item: ChecklistItem) {
        item.isDone.toggle()
    }

    func region(for trip: Trip) -> MKCoordinateRegion {
        guard let first = trip.sortedStops.first else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090),
                span: MKCoordinateSpan(latitudeDelta: 4.5, longitudeDelta: 4.5)
            )
        }

        return MKCoordinateRegion(
            center: first.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.75, longitudeDelta: 0.75)
        )
    }

    func summaryText(for trip: Trip) -> String {
        var lines: [String] = [
            "🌈 \(trip.title)",
            "Dates: \(trip.startDate.shortDate) - \(trip.endDate.shortDate)",
            "Duration: \(trip.durationText)",
            "",
            "Stops:"
        ]

        for stop in trip.sortedStops {
            lines.append("• \(stop.placeName) — \(stop.date.shortDate)")
        }

        lines.append("")
        lines.append("Checklist:")

        for item in trip.sortedChecklist {
            lines.append("\(item.isDone ? "✅" : "⬜️") \(item.title)")
        }

        return lines.joined(separator: "\n")
    }
}
