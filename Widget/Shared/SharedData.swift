//
//  SharedData.swift
//  Widget
//
//  Created by Vu Cao Nguyen on 9/10/26.
//

import Foundation

enum AppGroup {
    static let id = "group.Nguyencaovu.Widget"
    static let widgetKind = "MyWidget"
}

struct SharedData: Codable {
    var title: String
    var value: String
    var updateAt: Date
    
    private static let key = "sharedData"
    private static var defaults: UserDefaults? { UserDefaults(suiteName: AppGroup.id) }
    
    
    static let sample = SharedData(title: "Ví Dụ", value: "123", updateAt: .now)
    
    func save() {
        guard let data = try? JSONEncoder().encode(self) else { return }
        Self.defaults?.set(data, forKey: Self.key)
    }
    
    static func load() -> SharedData? {
        guard let data = defaults?.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(SharedData.self, from: data)
    }
}
