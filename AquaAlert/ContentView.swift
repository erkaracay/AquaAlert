//
//  ContentView.swift
//  AquaAlert
//
//  Created by Suphi Erkin Karaçay on 6.11.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var waterIntake: WaterIntake
    var onBackToCalculator: () -> Void

    @State private var totalWaterIntake: Double = 0
    @State private var intakeToAdd: String = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
                .background(Color.clear.contentShape(Rectangle()))

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
                        let normalizedIntake = max(0, min(totalWaterIntake, waterIntake.dailyGoal))
                        let fillHeight = (normalizedIntake / waterIntake.dailyGoal) * bottleHeight

                        ZStack(alignment: .bottom) {
                            Rectangle()
                                .fill(Color("Water"))
                                .frame(height: fillHeight)
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

                Text("\(Int(totalWaterIntake)) / \(Int(waterIntake.dailyGoal)) ml")
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

                Button(action: onBackToCalculator) {
                    Text("Back to Calculator")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
            .padding()
        }.dismissKeyboardOnTap()
        .onTapGesture { isInputFocused = false }
    }

    private func addWaterIntake() {
        if let intake = Double(intakeToAdd), intake > 0 {
            withAnimation {
                totalWaterIntake += intake
                if totalWaterIntake > waterIntake.dailyGoal {
                    totalWaterIntake = waterIntake.dailyGoal
                }
            }
            intakeToAdd = ""
        }
    }
}

#Preview {
    ContentView(
        waterIntake: WaterIntake(dailyGoal: 2500),
        onBackToCalculator: { print("Navigating back to CalculatorView") }
    )
}
