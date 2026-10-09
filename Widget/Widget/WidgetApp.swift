//
//  WidgetApp.swift
//  Widget
//
//  Created by Vu Cao Nguyen on 9/10/26.
//

import SwiftUI

struct WidgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    print("Opened from widget:", url)   // url = mywidget://open
                }
        }
    }
}
