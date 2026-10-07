//
//  Notes_is_SwiftDataApp.swift
//  Notes-is-SwiftData
//
//  Created by Vu Cao Nguyen on 8/10/26.
//

import SwiftUI
import SwiftData

@main
struct Notes_is_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Note.self)
    }
}
