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
        HStack(alignment: .bottom) {
            if let baby = selectedBaby {
                ZStack {
                    Circle()
                        .foregroundStyle(Color("TextLight").opacity(0.75))
                        .frame(maxWidth: 50, maxHeight: 50)
                        .overlay(
                            Image(systemName: "person")
                                .font(.title2)
                                .foregroundStyle(Color("TextDark").opacity(0.75))
                        )
                    if true {
                        Image("ProfilePlaceholder")
                            .resizable()
                            .frame(maxWidth: 50, maxHeight: 50)
                            .clipShape(
                                Circle()
                            )
                    }
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("\(baby.displayName)")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("TextDark"))
                        .popOver(isPresented: $openBabySelector, arrowDirection: .up, content: {
                            Picker("Select Baby", selection: $selectedBaby) {
                                ForEach(babies, id: \ .id) { baby in
                                    Text(baby.displayName).tag(baby as Baby?)
                                }
                            }
                            .pickerStyle(.wheel)
                        })
                    Text(ageString(from: baby.birthDate ?? Date()))
                        .font(.footnote)
                        .fontWeight(.regular)
                        .foregroundStyle(Color("TextDark").opacity(0.75))
                }
            }
        }
        .padding(0)
        .onTapGesture {
            if showBabySelector {
                openBabySelector.toggle()
            }
        }
        .onChange(of: selectedBaby) {
            self.openBabySelector = false
        }
    }

    func ageString(from birthdate: Date) -> String {
        let calendar = Calendar.current
        let now = Date()

        let components = calendar.dateComponents([.year, .month, .day], from: birthdate, to: now)

        if let years = components.year, years >= 1 {
            if let months = components.month, months > 0 {
                return "\(years) year\(years > 1 ? "s" : ""), \(months) month\(months > 1 ? "s" : "")"
            } else {
                return "\(years) year\(years > 1 ? "s" : "")"
            }
        } else if let months = components.month, months >= 1 {
            if let days = components.day, days > 0 {
                return "\(months) month\(months > 1 ? "s" : ""), \(days) day\(days > 1 ? "s" : "")"
            } else {
                return "\(months) month\(months > 1 ? "s" : "")"
            }
        } else if let days = components.day, days > 0 {
            return "\(days) day\(days > 1 ? "s" : "")"
        } else {
            return "0 days"
        }
    }
}
