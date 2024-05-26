import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var currentOperation: CalculatorButton? = nil
    @State private var firstOperand: Double? = nil
    @State private var secondOperand: Double? = nil
    @State private var isEnteringSecondOperand = false
    
    let buttons: [[CalculatorButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equals]
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    Text(display)
                        .foregroundColor(.white)
                        .font(.system(size: 64))
                        .padding()
                }
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                self.didTap(button: button)
                            }) {
                                Text(button.title)
                                    .font(.system(size: 32))
                                    .frame(width: self.buttonWidth(button: button), height: self.buttonHeight())
                                    .background(button.backgroundColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(button: button) / 2)
                            }
                        }
                    }
                }
            }
            .padding(.bottom)
        }
    }
    
    func buttonWidth(button: CalculatorButton) -> CGFloat {
        if button == .zero {
            return (UIScreen.main.bounds.width - 5 * 12) / 4 * 2
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
    func didTap(button: CalculatorButton) {
        switch button {
        case .clear:
            display = "0"
            currentOperation = nil
            firstOperand = nil
            secondOperand = nil
            isEnteringSecondOperand = false
            
        case .decimal:
            if !display.contains(".") {
                display.append(".")
            }
            
        case .negative:
            if let value = Double(display) {
                display = String(-value)
            }
            
        case .percent:
            if let value = Double(display) {
                display = String(value / 100)
            }
            
        case .add, .subtract, .multiply, .divide:
            if let value = Double(display) {
                firstOperand = value
                currentOperation = button
                isEnteringSecondOperand = true
                display = "0"
            }
            
        case .equals:
            if let operation = currentOperation, let firstValue = firstOperand, let secondValue = Double(display) {
                switch operation {
                case .add:
                    display = String(firstValue + secondValue)
                case .subtract:
                    display = String(firstValue - secondValue)
                case .multiply:
                    display = String(firstValue * secondValue)
                case .divide:
                    display = secondValue != 0 ? String(firstValue / secondValue) : "Error"
                default:
                    break
                }
                currentOperation = nil
                firstOperand = nil
                secondOperand = nil
                isEnteringSecondOperand = false
            }
            
        default:
            if isEnteringSecondOperand {
                display = button.title
                isEnteringSecondOperand = false
            } else {
                if display == "0" {
                    display = button.title
                } else {
                    display.append(contentsOf: button.title)
                }
            }
        }
    }
}

enum CalculatorButton: String {
    case zero, one, two, three, four, five, six, seven, eight, nine
    case add, subtract, multiply, divide, equals
    case clear, decimal, negative, percent
    
    var title: String {
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .add: return "+"
        case .subtract: return "-"
        case .multiply: return "×"
        case .divide: return "÷"
        case .equals: return "="
        case .clear: return "AC"
        case .decimal: return "."
        case .negative: return "+/-"
        case .percent: return "%"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equals:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(.darkGray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
