import Foundation
import SwiftData

struct SampleDataFactory {
    static func seedIfNeeded(in context: ModelContext) {
        let descriptor = FetchDescriptor<Trip>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }

        let start = Calendar.current.date(byAdding: .day, value: 7, to: .now) ?? .now
        let end = Calendar.current.date(byAdding: .day, value: 12, to: .now) ?? .now

        let trip = Trip(
            title: "Golden Peaks Loop",
            coverPhotoName: "mountain.2.fill",
            startDate: start,
            endDate: end,
            notes: "Scenic road trip with coffee towns, viewpoints, and easy hikes.",
            colorHex: "#FF7F50"
        )

        let stops = [
            TripStop(placeName: "Sunrise Point", address: "10 Ridgeview Rd", date: start, notes: "Arrive before 7:30 AM", latitude: 37.3349, longitude: -122.0090, orderIndex: 0),
            TripStop(placeName: "Pine Market", address: "42 Forest Ave", date: start.addingTimeInterval(60 * 60 * 24), notes: "Grab picnic supplies", latitude: 37.7749, longitude: -122.4194, orderIndex: 1),
            TripStop(placeName: "Lakewind Cabins", address: "88 Shoreline Dr", date: end, notes: "Check-in by 5 PM", latitude: 36.6002, longitude: -121.8947, orderIndex: 2)
        ]

        let checklist = [
            ChecklistItem(title: "Pack hiking shoes", orderIndex: 0),
            ChecklistItem(title: "Download offline route pack", orderIndex: 1),
            ChecklistItem(title: "Charge camera battery", orderIndex: 2)
        ]

        stops.forEach {
            $0.trip = trip
            trip.stops.append($0)
        }

        checklist.forEach {
            $0.trip = trip
            trip.checklist.append($0)
        }

        context.insert(trip)
        try? context.save()
    }
}
