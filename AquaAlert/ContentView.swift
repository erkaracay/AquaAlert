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
    @State private var wavePhase: CGFloat = 0.0

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    Text("Daily Water Intake")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("HeaderText"))
                        .padding(.top, 20)
                    
                    ZStack {
                        BottleShape()
                            .stroke(Color.black, lineWidth: 2)
                            .frame(width: 200, height: 400)
                        
                        GeometryReader { geometry in
                            let bottleHeight = geometry.size.height
                            let normalizedIntake = max(0, min(totalWaterIntake, waterIntake.dailyGoal))
                            
                            // Dolum yüksekliği hesaplama
                            let fillHeight = (normalizedIntake / waterIntake.dailyGoal) * bottleHeight * 2
                            
                            // Minimum görünürlük için alt limit
                            let adjustedFillHeight = max(fillHeight, 150) // Min 5 piksel dolum görünür
                            
                            ZStack(alignment: .bottom) {
                                WaveShape(amplitude: 10, frequency: 2, phase: wavePhase)
                                    .fill(Color("Water"))
                                    .frame(width: geometry.size.width, height: adjustedFillHeight)
                                    .offset(y: bottleHeight - adjustedFillHeight)
                                    .onAppear {
                                        withAnimation(.linear(duration: 11).repeatForever(autoreverses: false)) {
                                            wavePhase = .pi * 2
                                        }
                                    }
                            }
                        }
                        
                        .frame(width: 200, height: 400)
                        .mask(
                            BottleShape()
                                .frame(width: 200, height: 400)
                        )
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
