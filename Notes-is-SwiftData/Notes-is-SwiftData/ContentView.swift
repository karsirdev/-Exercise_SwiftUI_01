//
//  ContentView.swift
//  Notes-is-SwiftData
//
//  Created by Vu Cao Nguyen on 8/10/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.createdAt, order: .reverse) private var notes: [Note]
    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    VStack(alignment: .leading) {
                        Text(note.title)
                            .font(.headline)
                        Text(note.content)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Thêm") { addNote() }
                }
            }
        }
    }
    private func addNote() {
        let note = Note(title: "Ghi chú mới", content: "Nội dung")
        modelContext.insert(note)
    }

    private func deleteNotes(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(notes[index])
        }
    }
}



#Preview {
    ContentView()
        .modelContainer(for: Note.self, inMemory: true)
}
