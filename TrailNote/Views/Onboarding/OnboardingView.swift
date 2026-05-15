import SwiftUI

struct OnboardingView: View {
    let onGetStarted: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [.orange, .pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "map.circle.fill")
                    .font(.system(size: 90))
                    .foregroundStyle(.white)

                Text("TrailNote")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Plan your next adventure with colorful trips, map-friendly stops, and easy checklists.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.95))
                    .padding(.horizontal)

                FeatureCardRow()

                Spacer()

                Button(action: onGetStarted) {
                    Text("Start with Sample Trip")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.purple)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal)
                }

                Text("Original UI crafted for TrailNote. No third-party app branding used.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.bottom)
            }
        }
    }
}

private struct FeatureCardRow: View {
    var body: some View {
        HStack(spacing: 12) {
            feature(icon: "map.fill", title: "Map Stops")
            feature(icon: "checklist", title: "Trip Tasks")
            feature(icon: "square.and.arrow.up", title: "Easy Share")
        }
        .padding(.horizontal)
    }

    private func feature(icon: String, title: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.white.opacity(0.18))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    OnboardingView(onGetStarted: {})
}
