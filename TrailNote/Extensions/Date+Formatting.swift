import Foundation

extension Date {
    var shortDate: String {
        formatted(.dateTime.month(.abbreviated).day().year())
    }

    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
