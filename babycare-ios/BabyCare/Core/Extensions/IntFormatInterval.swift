public extension Int {
    func formatAsDurationString(_ includeSeconds: Bool = true) -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60

        if includeSeconds {
            let seconds = self % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", hours, minutes)
        }
    }
}
