import Foundation
import SwiftData
import MapKit

@Model
final class TripStop {
    var id: UUID
    var placeName: String
    var address: String
    var date: Date
    var notes: String
    var latitude: Double
    var longitude: Double
    var orderIndex: Int

    var trip: Trip?

    init(
        id: UUID = UUID(),
        placeName: String,
        address: String,
        date: Date,
        notes: String,
        latitude: Double,
        longitude: Double,
        orderIndex: Int
    ) {
        self.id = id
        self.placeName = placeName
        self.address = address
        self.date = date
        self.notes = notes
        self.latitude = latitude
        self.longitude = longitude
        self.orderIndex = orderIndex
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
