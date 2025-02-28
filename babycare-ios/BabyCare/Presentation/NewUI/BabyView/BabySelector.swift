import Foundation
import os
import SwiftUI

struct BabySelector: View {
    let babies: [Baby]
    @Binding var selectedBaby: Baby?

    @State private var openBabySelector: Bool = false

    var showBabySelector: Bool {
        return babies.count > 1
    }

    var body: some View {
        HStack {
            if let baby = selectedBaby {
                Text("\(baby.displayName)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("TextDark"))
                    .onTapGesture {
                        if showBabySelector {
                            openBabySelector.toggle()
                        }
                    }
            }

            if showBabySelector {
                Image(systemName: "chevron.down")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        if showBabySelector {
                            openBabySelector.toggle()
                        }
                    }
                    .popOver(isPresented: $openBabySelector, arrowDirection: .up, content: {
                        Picker("Select Baby", selection: $selectedBaby) {
                            ForEach(babies, id: \ .id) { baby in
                                Text(baby.displayName).tag(baby as Baby?)
                            }
                        }
                        .pickerStyle(.wheel)
                    })
            }
        }
        .onChange(of: selectedBaby) {
            self.openBabySelector = false
        }
    }
}
