import SwiftUI

struct CalculatorView: View {
    @FocusState private var isInputFocused: Bool
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var gender: String = "Male"
    @State private var age: Double = 21
    
    // Computed Property to Calculate Water Needs
    private var waterNeeds: String {
        guard let weightValue = Double(weight),
              let heightValue = Double(height) else {
            return "Invalid input for weight or height"
        }
        
        var baseWater = weightValue * 0.033 // Basic formula: 33ml per kg
        
        // Adjust based on gender
        baseWater += gender == "Male" ? 0.5 : 0
        
        // Adjust based on age
        if age < 30 {
            baseWater += 0.2
        } else if age >= 30 && age < 55 {
            baseWater += 0.1
        }
        
        // Add height adjustment (optional tweak)
        if heightValue > 170 {
            baseWater += 0.3
        }
        
        return String(format: "%.2f liters/day", baseWater)
    }
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
                .onTapGesture {
                    isInputFocused = false
                }
            
            VStack {
                Text("Calculate Your Water Needs")
                    .foregroundColor(Color.headerText)
                    .fontWeight(.semibold)
                    .font(.title)
                
                Form {
                    Section("Height and Weight") {
                        TextField("Weight (kg)", text: $weight)
                            .keyboardType(.decimalPad)
                            .focused($isInputFocused)
                        
                        TextField("Height (cm)", text: $height)
                            .keyboardType(.decimalPad)
                            .focused($isInputFocused)
                    }
                    
                    Section("Age and Gender") {
                        VStack(alignment: .leading) {
                            Text("Age: \(Int(age))")
                                .fontWeight(.semibold)
                                .frame(alignment: .center)
                            
                            Slider(value: $age, in: 18...99, step: 1)
                                .accentColor(Color.water)
                        }
                        .padding(.vertical, 8)
                        
                        Picker("Gender", selection: $gender) {
                            ForEach(["Male", "Female"], id: \.self) {
                                Text($0).tag($0)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .tint(Color.water)
                
                // Centered Water Needs Text
                Text("Your daily water needs: \(waterNeeds)")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(Color.primary)
            }
            .padding()
        }
    }
}

#Preview {
    CalculatorView()
}
