import SwiftUI
import SwiftData

struct RootView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            if hasSeenOnboarding {
                TripListView()
            } else {
                OnboardingView {
                    SampleDataFactory.seedIfNeeded(in: modelContext)
                    hasSeenOnboarding = true
                }
            }
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: [Trip.self, TripStop.self, ChecklistItem.self], inMemory: true)
}
