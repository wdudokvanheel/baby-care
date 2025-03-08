import SwiftUI

struct SleepListView: View {
    let date: Date
    let items: [SleepAction]
    let select: (SleepAction) -> Void

    @State private var selectedSleep: SleepAction?

    private let gridColumns = [
        GridItem(.flexible(minimum: 5), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(minimum: 5), alignment: .trailing)
    ]

    var visibleItems: [SleepAction] {
        self.items
            .filter { action in
                action.end != nil
            }
            .suffix(3)
    }

    var body: some View {
        Panel {
            VStack {
                Grid(verticalSpacing: 4) {
                    ForEach(visibleItems, id: \.self) { sleep in
                        GridRow {
                            Image(systemName:
                                sleep.night != nil && sleep.night == true ?
                                    "moon" :
                                    "sun.max"
                            )
                            .foregroundStyle(
                                sleep.night != nil && sleep.night == true ?
                                    Color("SleepColor") :
                                    Color("NapColor")
                            )

                            HStack {
                                Text(sleep.start.formatDateTimeAsRelativeString())
                                    .frame(alignment: .leading)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)

                            HStack {
                                Spacer()
                                Text("\(sleep.start.timeIntervalToShortString(to: sleep.end ?? Date()))")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            select(sleep)
                        }
                    }
                }
                .foregroundStyle(Color("TextDark"))
                .font(.subheadline)
                .fontWeight(.light)
            }
            .padding(.trailing, 8)
            .padding(.vertical, 0)
        }
    }

    func formatRelativeDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter.string(from: date)
    }
}
