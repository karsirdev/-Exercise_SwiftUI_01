//
//  Note.swift
//  Notes-is-SwiftData
//
//  Created by Vu Cao Nguyen on 8/10/26.
//

import SwiftData
import Foundation

@Model

final class Note {
    var title: String
    var content: String
    var createdAt: Date
    
    init(title: String, content: String, createdAt: Date = .now) {
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }
}
