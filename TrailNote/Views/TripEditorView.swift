import SwiftUI

struct TripEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = TripEditorViewModel()
    @EnvironmentObject private var purchaseManager: PurchaseManager

    let onSave: (Trip) -> Void

    private let palette: [Color] = [.orange, .pink, .purple, .blue, .mint, .teal]

    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    TextField("Trip title", text: $viewModel.title)
                    DatePicker("Start date", selection: $viewModel.startDate, displayedComponents: .date)
                    DatePicker("End date", selection: $viewModel.endDate, displayedComponents: .date)
                    TextField("Notes", text: $viewModel.notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }

                Section("Cover icon") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.availableSymbols, id: \.self) { symbol in
                                Button {
                                    viewModel.coverPhotoName = symbol
                                } label: {
                                    Image(systemName: symbol)
                                        .padding()
                                        .background(viewModel.coverPhotoName == symbol ? Color.orange.opacity(0.25) : Color.gray.opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                Section("Trip color") {
                    if purchaseManager.isPremium {
                        HStack {
                            ForEach(palette, id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 30, height: 30)
                                    .overlay {
                                        Circle().stroke(.white, lineWidth: viewModel.selectedColor == color ? 3 : 0)
                                    }
                                    .onTapGesture {
                                        viewModel.selectedColor = color
                                    }
                            }
                        }
                    } else {
                        Label("Custom colors are Premium", systemImage: "lock.fill")
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("New Trip")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(viewModel.makeTrip())
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

#Preview {
    TripEditorView(onSave: { _ in })
        .environmentObject(PurchaseManager())
}
