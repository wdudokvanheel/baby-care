import SwiftUI

struct DeleteButton: View {
    let onDeleteConfirmed: () -> Void

    @State private var showingAlert = false

    var body: some View {
        Button(action: {
            self.showingAlert = true
        }) {
            HStack {
                Image(systemName: "trash")
                Spacer()
                Text("Delete")
                Spacer()
            }
            .foregroundColor(.white)
            .fontWeight(.semibold)
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .tint(.red)
        .alert("Are you sure you want to delete this?", isPresented: $showingAlert) {
            Button("Delete", role: .destructive) {
                onDeleteConfirmed()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
