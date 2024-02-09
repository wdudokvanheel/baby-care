import SwiftUI

struct DayView: View {
    @ObservedObject
    var model: BabyViewModel

    @State
    private var date = Date()

    init(model: BabyViewModel) {
        self.model = model
    }

    var body: some View {
        VStack(alignment: .center) {
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
            ScrollView {
                DaySummaryView(model, date)
            }
        }
        .navigationTitle("Summary for \(date.formatDateAsRelativeString())")
    }
}
