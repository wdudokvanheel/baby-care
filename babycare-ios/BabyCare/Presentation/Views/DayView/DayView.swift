import SwiftUI

struct DayView: View {
    @ObservedObject
    var model: BabyViewModel

    @State
    private var date = Date()

    var body: some View {
        VStack(alignment: .center) {
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
            ScrollView {
                DaySummaryView(model, $date)
            }
        }
        .navigationTitle("Summary for \(date.formatDateAsRelativeString())")
    }
}
