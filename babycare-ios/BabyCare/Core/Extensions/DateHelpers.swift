import Foundation

extension Date {
    /// Compares this date with another date, disregarding the time component.
    /// - Parameter date: The date to compare with.
    /// - Returns: `true` if both dates are the same day, month, and year; otherwise, `false`.
    func isSameDateIgnoringTime(as date: Date) -> Bool {
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.year, .month, .day]

        let selfComponents = calendar.dateComponents(components, from: self)
        let otherComponents = calendar.dateComponents(components, from: date)

        return selfComponents.year == otherComponents.year &&
            selfComponents.month == otherComponents.month &&
            selfComponents.day == otherComponents.day
    }

    func formatDateAsRelativeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter.string(from: self)
    }

    func formatDateTimeAsRelativeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter.string(from: self)
    }

    func formatTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter.string(from: self)
    }

    func timeIntervalToString(to endDate: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]

        let interval = endDate.timeIntervalSince(self)
        return formatter.string(from: TimeInterval(interval)) ?? "N/A"
    }

    /// Checks if a given date's time is later than the time of the date instance it is called on.
    ///
    /// - Parameter date: The date to compare with.
    /// - Returns: `true` if the given date's time is later than the instance's time, ignoring the calendar date.
    func isTimeLaterThan(date: Date) -> Bool {
        // Get the current calendar
        let calendar = Calendar.current

        // Extract hour, minute, and second components from both dates
        let componentsSelf = calendar.dateComponents([.hour, .minute, .second], from: self)
        let componentsOther = calendar.dateComponents([.hour, .minute, .second], from: date)

        // Compare the components
        if let hourSelf = componentsSelf.hour, let minuteSelf = componentsSelf.minute, let secondSelf = componentsSelf.second,
           let hourOther = componentsOther.hour, let minuteOther = componentsOther.minute, let secondOther = componentsOther.second
        {
            if hourSelf < hourOther {
                return true
            } else if hourSelf == hourOther {
                if minuteSelf < minuteOther {
                    return true
                } else if minuteSelf == minuteOther {
                    return secondSelf < secondOther
                }
            }
        }

        // If the time is not later, return false
        return false
    }
}
