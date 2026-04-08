import SwiftUI
import SwiftData

struct TripListView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Query(sort: [SortDescriptor(\Trip.createdAt, order: .reverse)]) private var trips: [Trip]

    @State private var showAddTrip = false
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            Group {
                if trips.isEmpty {
                    EmptyStateView(
                        title: "No trips yet",
                        subtitle: "Create your first colorful itinerary and start pinning stops on the map.",
                        systemImage: "sparkles.map"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(trips) { trip in
                                NavigationLink(value: trip) {
                                    TripCardView(trip: trip)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("TrailNote")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink("Premium") {
                        PremiumView()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if !purchaseManager.isPremium && trips.count >= purchaseManager.freeTripLimit {
                            showPaywall = true
                        } else {
                            showAddTrip = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: Trip.self) { trip in
                TripDetailView(trip: trip)
            }
            .sheet(isPresented: $showAddTrip) {
                TripEditorView { trip in
                    context.insert(trip)
                }
            }
            .sheet(isPresented: $showPaywall) {
                PremiumView()
            }
        }
    }
}

#Preview {
    TripListView()
        .environmentObject(PurchaseManager())
        .modelContainer(for: [Trip.self, TripStop.self, ChecklistItem.self], inMemory: true)
}
