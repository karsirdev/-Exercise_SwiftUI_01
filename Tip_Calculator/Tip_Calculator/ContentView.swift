//
//  ContentView.swift
//  Tip_Calculator
//
//  Created by Vu Cao Nguyen on 6/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var tipPerson = 15
    @State private var amount = ""
    @State private var people = 1
    
    private let tipOptiont = [10, 15, 20]
    
    private var bill: Double {
        Double(amount.replacingOccurrences(of: ",", with: ".")) ?? 0
    }
    private var tip: Double { bill * Double(tipPerson) / 100}
    private var total: Double { bill + tip }
    private var Person: Double { total / Double(max(people, 1)) }
    var body: some View {
        VStack (spacing: 14) {
            Form {
                Section("Số tiền") {
                    TextField("0", text: $amount)
                        .keyboardType(.decimalPad)
                        .padding(10)
                }
                
                Section("Tip %") {
                    Picker("%", selection: $tipPerson) {
                        ForEach(tipOptiont, id: \.self) { tipOptiont in
                            Text("\(tipOptiont)").tag(tipOptiont)
                        }
                    }
                    .padding(5)
                }
                
                Section("Chia đều") {
                    Stepper("Người: \(people)", value: $people)
                        .padding(10)
                }
                
                Section("Tổng") {
                    Text("Tip: \(tip, format: .number.precision(.fractionLength(0)))")
                    Text("Tổng: \(total, format: .number.precision(.fractionLength(0)))")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
