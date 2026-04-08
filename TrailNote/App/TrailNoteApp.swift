import SwiftUI
import SwiftData

@main
struct TrailNoteApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Trip.self,
            TripStop.self,
            ChecklistItem.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    @StateObject private var purchaseManager = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(purchaseManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
