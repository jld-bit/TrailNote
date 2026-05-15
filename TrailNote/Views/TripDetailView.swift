import SwiftUI
import MapKit
import SwiftData

struct TripDetailView: View {
    @Bindable var trip: Trip
    @StateObject private var viewModel = TripDetailViewModel()

    @State private var newStopName = ""
    @State private var newStopAddress = ""
    @State private var newStopNotes = ""
    @State private var newStopDate = Date()
    @State private var mapCameraPosition = MapCameraPosition.automatic
    @State private var showShare = false

    var body: some View {
        List {
            Section("Overview") {
                Text(trip.notes)
                Text("\(trip.startDate.shortDate) - \(trip.endDate.shortDate)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Map") {
                Map(position: $mapCameraPosition) {
                    ForEach(trip.sortedStops) { stop in
                        Annotation(stop.placeName, coordinate: stop.coordinate) {
                            VStack(spacing: 4) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundStyle(.red)
                                Text(stop.placeName)
                                    .font(.caption2)
                                    .padding(4)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                    }
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onAppear {
                    mapCameraPosition = .region(viewModel.region(for: trip))
                }
            }

            Section("Stops") {
                if trip.sortedStops.isEmpty {
                    EmptyStateView(title: "No stops yet", subtitle: "Add places to build your route.", systemImage: "map")
                } else {
                    ForEach(trip.sortedStops) { stop in
                        VStack(alignment: .leading, spacing: 3) {
                            Text(stop.placeName).font(.headline)
                            Text(stop.address).font(.subheadline).foregroundStyle(.secondary)
                            Text(stop.date.shortDate).font(.caption).foregroundStyle(.secondary)
                            if !stop.notes.isEmpty {
                                Text(stop.notes).font(.caption)
                            }
                        }
                    }
                    .onMove { source, destination in
                        viewModel.moveStops(in: trip, from: source, to: destination)
                    }
                }

                DisclosureGroup("Add stop") {
                    TextField("Place name", text: $newStopName)
                    TextField("Address", text: $newStopAddress)
                    DatePicker("Date", selection: $newStopDate, displayedComponents: .date)
                    TextField("Notes", text: $newStopNotes)
                    Button("Add Stop") {
                        addStop()
                    }
                    .disabled(newStopName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }

            Section("Checklist") {
                ForEach(trip.sortedChecklist) { item in
                    Button {
                        viewModel.toggleChecklist(item)
                    } label: {
                        HStack {
                            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                            Text(item.title)
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                }
                .onDelete { indexes in
                    trip.checklist.remove(atOffsets: indexes)
                }

                HStack {
                    TextField("Add task", text: $viewModel.newChecklistTitle)
                    Button("Add") {
                        viewModel.addChecklistItem(to: trip)
                    }
                }
            }
        }
        .navigationTitle(trip.title)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                EditButton()
                Button {
                    showShare = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showShare) {
            ShareTripView(trip: trip, summaryText: viewModel.summaryText(for: trip))
        }
    }

    private func addStop() {
        let stop = TripStop(
            placeName: newStopName,
            address: newStopAddress,
            date: newStopDate,
            notes: newStopNotes,
            latitude: 37.3349 + Double.random(in: -0.8...0.8),
            longitude: -122.0090 + Double.random(in: -0.8...0.8),
            orderIndex: trip.stops.count
        )
        stop.trip = trip
        trip.stops.append(stop)

        newStopName = ""
        newStopAddress = ""
        newStopNotes = ""
    }
}
