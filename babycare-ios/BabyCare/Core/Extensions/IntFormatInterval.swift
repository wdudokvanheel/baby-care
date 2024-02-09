public extension Int {
    func formatAsDurationString() -> String{
        return formatAsDurationString(true)
    }
    
    func formatAsDurationString(_ includeSeconds: Bool) -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60

        if includeSeconds {
            let seconds = self % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", hours, minutes)
        }
    }

    func formatAsDurationString(excludeHours: Bool = true) -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60

        if hours == 0, excludeHours {
            return String(format: "%02d:%02d", minutes, seconds)
        }
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
