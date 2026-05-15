import SwiftUI

struct PremiumView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                Text("TrailNote Premium")
                    .font(.largeTitle.bold())

                Label("Unlimited trips", systemImage: "infinity")
                Label("Custom color themes", systemImage: "paintpalette.fill")
                Label("Export as image", systemImage: "photo.on.rectangle")
                Label("Offline saved trip packs", systemImage: "tray.full.fill")

                if purchaseManager.isPremium {
                    Text("You're premium 🎉")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.green.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Button("Unlock Premium") {
                        Task {
                            try? await purchaseManager.purchasePremium()
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Restore Purchases") {
                        Task {
                            await purchaseManager.restore()
                        }
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Premium")
        }
    }
}

#Preview {
    PremiumView()
        .environmentObject(PurchaseManager())
}
