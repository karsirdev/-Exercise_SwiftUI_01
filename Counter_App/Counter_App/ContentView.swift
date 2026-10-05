//
//  ContentView.swift
//  Counter_App
//
//  Created by Vu Cao Nguyen on 6/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var count = 0
    var body: some View {
        VStack (spacing: 14) {
            Text("\(count)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundStyle(count < 0 ? .red : .primary)
                .contentTransition(.numericText())
            
            HStack (spacing: 16) {
                Button {
                    withAnimation { count -= 1 }
                } label: {
                    Image(systemName: "minus")
                }
                
                Button("Reset") {
                    withAnimation { count = 0 }
                }
                .tint(.gray)
                
                Button {
                    withAnimation { count += 1 }
                } label: {
                    Image(systemName: "plus")
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
