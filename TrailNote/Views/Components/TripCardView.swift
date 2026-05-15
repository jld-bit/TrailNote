import SwiftUI
import MapKit

struct TripCardView: View {
    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(trip.title, systemImage: trip.coverPhotoName)
                    .font(.headline)
                Spacer()
                Text(trip.durationText)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.white.opacity(0.35))
                    .clipShape(Capsule())
            }

            Text("\(trip.startDate.shortDate) - \(trip.endDate.shortDate)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if !trip.sortedStops.isEmpty {
                MiniMapPreview(stops: trip.sortedStops)
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Text(trip.notes)
                .font(.footnote)
                .lineLimit(2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(hex: trip.colorHex).opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct MiniMapPreview: View {
    let stops: [TripStop]

    var body: some View {
        Map {
            ForEach(stops) { stop in
                Marker(stop.placeName, coordinate: stop.coordinate)
            }
        }
        .allowsHitTesting(false)
    }
}
