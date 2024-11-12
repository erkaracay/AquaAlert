//
//  ContentView.swift
//  AquaAlert
//
//  Created by Suphi Erkin Karaçay on 6.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var totalWaterIntake: Double = 0
    @State private var dailyGoal: Double = 3000 // Customize for daily water goal
    @State private var intakeToAdd: String = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
                .onTapGesture {
                    isInputFocused = false
                }

            VStack(spacing: 16) {
                Text("Daily Water Intake")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("HeaderText"))
                    .padding(.top, 20)

                ZStack {
                    Image("FlaskImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 450, height: 450)

                    GeometryReader { geometry in
                        let bottleHeight = geometry.size.height
                        let normalizedIntake = max(0, min(totalWaterIntake, dailyGoal))
                        let fillHeight = (normalizedIntake / dailyGoal) * bottleHeight

                        ZStack(alignment: .bottom) {
                            Rectangle()
                                .fill(Color("Water"))
                                .frame(height: fillHeight) // Calculate height precisely
                                .animation(.easeInOut, value: totalWaterIntake)
                        }
                        .frame(height: bottleHeight, alignment: .bottom)
                        .mask(
                            Image("FlaskImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 450, height: 450)
                        )
                    }
                    .frame(width: 450, height: 450)
                }

                Text("\(Int(totalWaterIntake)) / \(Int(dailyGoal)) ml")
                    .font(.headline)
                    .foregroundColor(Color.black)
                    .padding(.top, 10)

                Spacer()

                HStack {
                    TextField("Enter ml", text: $intakeToAdd)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .focused($isInputFocused)
                        .frame(width: 100)
                        .background(Color.brown)
                        .cornerRadius(8)

                    Button(action: addWaterIntake) {
                        Text("Add Water")
                            .padding(12)
                            .background(Color("ButtonBackground"))
                            .foregroundColor(Color("ButtonText"))
                            .cornerRadius(10)
                    }
                }

                Spacer()
            }
            .padding()
        }
    }

    private func addWaterIntake() {
        if let intake = Double(intakeToAdd), intake > 0 {
            withAnimation {
                totalWaterIntake += intake
                if totalWaterIntake > dailyGoal {
                    totalWaterIntake = dailyGoal
                }
            }
            intakeToAdd = ""
        }
    }
}

#Preview {
    ContentView()
}
