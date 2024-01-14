import SwiftUI

struct MainView: View {
    @EnvironmentObject
    private var model: MainViewModel
    @State
    private var currentDate = Date()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button(action: {
                    model.toggleSleep()
                }) {
                    HStack {
                        Image(systemName: "moon.stars.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 40)
                        Spacer()
                        if let sleep = model.sleep {
                            Text("Stop sleep")
                                .font(.title)
                            Spacer()
                            Text("\(timeDifference(from: sleep.start!))")
                                .font(.footnote)
                        }
                        else {
                            Text("Start sleep")
                                .font(.title)
                            Spacer()
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }

                Button(action: {
                    model.toggleFeed()
                }) {
                    HStack {
                        Image(systemName: "mug.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 40)
                        Spacer()
                        if let feed = model.feed {
                            Text("Stop feeding")
                                .font(.title)
                            Spacer()
                            Text("\(timeDifference(from: feed.start!))")
                                .font(.footnote)
                        }
                        else {
                            Text("Start feeding")
                                .font(.title)
                            Spacer()
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                }
            }
            .padding()
            .navigationBarTitle("Little Tiny Baby Care")
            .onReceive(timer) { input in
                currentDate = input
            }
        }
    }

    func timeDifference(from date: Date?) -> String {
        guard let startDate = date else { return "Unknown" }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: currentDate)

        var timeString = ""
        if let hour = components.hour, hour > 0 {
            timeString += "\(hour):"
        }

        let minute = components.minute ?? 0
        let second = components.second ?? 0

        timeString += String(format: "%02d:%02d", minute, second)
        return timeString
    }
}
