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

            ScrollView { // Adding ScrollView to make the view scrollable when keyboard appears
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
                                    .padding(.bottom, 20) // Adjust this value based on the offset
                                    .animation(.easeInOut, value: totalWaterIntake)
                            }
                            .frame(height: bottleHeight, alignment: .bottom)
                            .mask(
                                Image("FlaskImage")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width, height: bottleHeight)
                                    .alignmentGuide(.bottom) { d in d[.bottom] }
                            )
                        }
                        .frame(width: 450, height: 450)

                    }
                    
                    VStack {
                        Text("\(Int(totalWaterIntake)) / \(Int(waterIntake.dailyGoal)) ml")
                            .font(.headline)
                            .foregroundColor(Color.black)
                            .padding(.top, 10)
                        
                        Button(action: onBackToCalculator) {
                            Text("Back to Calculator")
                                .font(.caption)
                                .padding(.top, 1)
                                .underline()
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        TextField("Enter ml", text: $intakeToAdd)
                            .keyboardType(.decimalPad)
                            .focused($isInputFocused)
                            .frame(width: 100)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                            .underlineTextField()
                        
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

extension View {
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(.water)
            .padding(10)
    }
}

#Preview {
    ContentView(
        waterIntake: WaterIntake(dailyGoal: 2500),
        onBackToCalculator: { print("Navigating back to CalculatorView") }
    )
}
