//
//  MyWidget.swift
//  Widget
//
//  Created by Vu Cao Nguyen on 9/10/26.
//

import SwiftUI
import WidgetKit

@main
struct MyWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: AppGroup.widgetKind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Widget")
        .description("Hiển thị dữ liệu từ app.")
        .supportedFamilies([.systemSmall, .systemMedium])   // FR1
    }
}

#Preview(as: .systemSmall) {
    MyWidget()
} timeline: {
    DataEntry(date: .now, data: .sample)
    DataEntry(date: .now, data: nil)
}
