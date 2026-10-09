//
//  ContentView.swift
//  Widget
//
//  Created by Vu Cao Nguyen on 9/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var title = ""
    @State private var value = ""

    var body: some View {
        Form {
            TextField("Tiêu đề", text: $title)
            TextField("Giá trị", text: $value)
            Button("Lưu và cập nhật widget") {
                WidgetService.update(
                    SharedData(title: title, value: value, updateAt: .now)
                )
            }
        }
        .onAppear {
            if let saved = SharedData.load() {
                title = saved.title
                value = saved.value
            }
        }
    }
}

#Preview { ContentView() }
