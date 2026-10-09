//
//  TimeLineProvider.swift
//  Widget
//
//  Created by Vu Cao Nguyen on 9/10/26.
//

import WidgetKit

struct DataEntry: TimelineEntry {
    let date: Date
    let data: SharedData?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DataEntry {
        DataEntry(date: .now, data: .sample)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DataEntry) -> Void) {
        completion(DataEntry(date: .now, data: SharedData.load() ?? .sample))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DataEntry>) -> Void) {
        let entry = DataEntry(date: .now, data: SharedData.load())
        let next = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}
