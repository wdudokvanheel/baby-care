import SwiftData
import SwiftUI

struct ContentView: View {
    let container: ModelContainer?

    init() {
        do {
            self.container = try ModelContainer(for: BabyAction.self)
        }
        catch {
            print("Data Source Error")
            container = nil
        }
    }

    var body: some View {

        if let container = container {
            MainView()
                .environmentObject(MainViewModel(dataContainer: container))
        }
    }
}
