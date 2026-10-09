//
//  WidgetService.swift
//  Widget
//
//  Created by Vu Cao Nguyen on 10/10/26.
//

import WidgetKit

enum WidgetService {
    static func update(_ data: SharedData) {
        data.save()
        WidgetCenter.shared.reloadTimelines(ofKind: AppGroup.widgetKind)   
    }
}
