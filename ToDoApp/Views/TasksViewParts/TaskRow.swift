//
//  TaskRow.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 17.02.2021.
//

import SwiftUI

struct TaskRow: View {
    @State var title = ""
    @State var note = ""
    @State var editing = false
    @State var task = Task(title: "Very big title", dateDue: Date(), status: .new, note: "Optional note here")
    var body: some View {
        HStack(alignment: .top) {
            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundColor(task.status == .new ? Color.gray.opacity(0.5) : .green)
                    .frame(width: 24, height: 24)
                Color.clear
                    .frame(width: 30, height: 30)
                if (task.status == .done) {
                    Circle()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.green)
                }
            }
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                task.status = (task.status == .new ? .done : .new)
            }
            VStack(alignment: .leading, spacing: 4) {
                TextField("", text: $title, onEditingChanged: { editing = $0 })
                    .foregroundColor(.primary)
                if (note != "") {
                    TextField("", text: $note, onEditingChanged: { editing = $0 })
                        .foregroundColor(.secondary)
                }
            }
            if (editing) {
                Button(action: {}, label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(4)
                })
            }
            Spacer(minLength: 0)
        }
        .onAppear {
            title = task.title
            note = task.note
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow()
            .preferredColorScheme(.light)
            .previewLayout(.fixed(width: 375, height: 100))
        TaskRow()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 100))
        TaskRow(task: Task(title: "Very big title", dateDue: Date(), status: .done, note: "Optional note here"))
            .preferredColorScheme(.light)
            .previewLayout(.fixed(width: 375, height: 100))
        TaskRow(task: Task(title: "Very big title", dateDue: Date(), status: .done, note: "Optional note here"))
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 100))
    }
}
