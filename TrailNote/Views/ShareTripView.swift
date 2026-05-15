import SwiftUI

struct ShareTripView: View {
    let trip: Trip
    let summaryText: String

    @State private var shareItems: [Any] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TripSummaryCard(trip: trip, summaryText: summaryText)
                    .padding()

                Button("Share as Text") {
                    shareItems = [summaryText]
                }
                .buttonStyle(.borderedProminent)

                Button("Share as Image") {
                    let renderer = ImageRenderer(content: TripSummaryCard(trip: trip, summaryText: summaryText).padding())
                    if let image = renderer.uiImage {
                        shareItems = [image]
                    }
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .navigationTitle("Share Trip")
            .sheet(isPresented: Binding(get: { !shareItems.isEmpty }, set: { if !$0 { shareItems = [] } })) {
                ActivityViewController(activityItems: shareItems)
            }
        }
    }
}

struct TripSummaryCard: View {
    let trip: Trip
    let summaryText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(trip.title, systemImage: trip.coverPhotoName)
                .font(.title2.bold())
            Text("\(trip.startDate.shortDate) - \(trip.endDate.shortDate)")
                .font(.subheadline)

            Divider()

            Text(summaryText)
                .font(.footnote)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: trip.colorHex).opacity(0.2))
        )
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
