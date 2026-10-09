//
//  WidgetEntryView.swift
//  Widget
//
//  Created by Vu Cao Nguyen on 9/10/26.
//

import SwiftUI
import WidgetKit

struct WidgetEntryView: View {
    let entry: DataEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            if let data = entry.data {
                Text(data.title).font(.caption).foregroundStyle(.secondary)
                Text(data.value).font(.title).bold()
                Spacer()
                Text(data.updateAt, style: .time).font(.caption2).foregroundStyle(.secondary)
            } else {
                Text("Chưa có dữ liệu").font(.caption).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .widgetURL(URL(string: "mywidget://open"))
    }
}
