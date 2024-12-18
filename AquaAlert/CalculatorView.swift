import SwiftUI

struct CalculatorView: View {
    @ObservedObject var waterIntake: WaterIntake
    var onComplete: () -> Void

    @State private var weight: String = ""
    @State private var gender: String = "Male"
    @State private var age: Double = 21
    @State private var exerciseDuration: Double = 0
    @State private var climate: String = "Temperate"
    @State private var isPregnantOrBreastfeeding: Bool = false

    @FocusState private var isWeightFieldFocused: Bool

    // Computed property to validate weight
    private var isWeightValid: Bool {
        guard let weightValue = Double(weight), weightValue > 0 else {
            return false
        }
        return true
    }

    private var calculatedWaterIntake: Double {
        guard let weightValue = Double(weight) else {
            return 0.0
        }

        var baseWater = weightValue * 35.0

        if age > 55 {
            baseWater *= 0.9
        }

        if gender == "Male" {
            baseWater *= 1.1
        } else {
            baseWater *= 0.9
        }

        let additionalWaterFromExercise = (exerciseDuration / 30) * 350.0
        baseWater += additionalWaterFromExercise

        switch climate {
        case "Hot":
            baseWater += 500.0
        case "Cold":
            baseWater -= 200.0
        default:
            break
        }

        if isPregnantOrBreastfeeding {
            baseWater += 500.0
        }

        return baseWater
    }

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { isWeightFieldFocused = false }

            NavigationView {
                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("Weight (kg)", text: $weight)
                            .keyboardType(.decimalPad)
                            .focused($isWeightFieldFocused)
                        VStack(alignment: .leading) {
                            Text("Age: \(Int(age))")
                                .fontWeight(.semibold)

                            HStack() {
                                Button("", systemImage: "minus"){
                                    if age > 18 {
                                        age -= 1
                                    }
                                }.disabled(age == 18)
                                    .buttonStyle(BorderlessButtonStyle())
                                
                                Slider(value: $age, in: 18...99, step: 1)
                                    .accentColor(Color.blue)
                                
                                Button("", systemImage: "plus"){
                                    if age < 99 {
                                        age += 1
                                    }
                                }.disabled(age == 99)
                                    .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                        .padding(.vertical, 8)

                        Picker("Gender", selection: $gender) {
                            ForEach(["Male", "Female"], id: \ .self) {
                                Text($0).tag($0)
                            }
                        }
                    }

                    Section(header: Text("Physical Activity and Climate")) {
                        VStack(alignment: .leading) {
                            Text("Daily Exercise Duration: \(Int(exerciseDuration)) minutes")
                                .fontWeight(.semibold)

                            Slider(value: $exerciseDuration, in: 0...120, step: 10)
                                .accentColor(Color.blue)
                        }
                        .padding(.vertical, 8)

                        Picker("Climate Conditions", selection: $climate) {
                            ForEach(["Temperate", "Hot", "Cold"], id: \ .self) {
                                Text($0).tag($0)
                            }
                        }
                    }

                    Section(header: Text("Special Conditions")) {
                        Toggle("Pregnant or Breastfeeding", isOn: $isPregnantOrBreastfeeding)
                            .disabled(gender == "Male")
                            .onChange(of: gender) { _, newGender in
                                if newGender == "Male" {
                                    isPregnantOrBreastfeeding = false
                                }
                            }
                    }

                    Section(footer: Text("Your daily water intake: \(calculatedWaterIntake / 1000, specifier: "%.2f") liters")) {
                        Button("Done") {
                            waterIntake.dailyGoal = calculatedWaterIntake
                            onComplete()
                        }
                        .disabled(!isWeightValid)
                    }
                }
                .navigationTitle("Water Intake Calculator")
            }
        }
    }
}

#Preview {
    CalculatorView(
        waterIntake: WaterIntake(dailyGoal: 2000), onComplete: {}
    )
}
