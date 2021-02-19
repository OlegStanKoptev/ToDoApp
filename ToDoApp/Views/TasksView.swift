//
//  TasksView.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 17.02.2021.
//

import SwiftUI

struct TasksView: View {
    @State var list: TasksList
    
    var body: some View {
        List(list.tasks) { task in
            TaskRow(task: task)
        }
        .listStyle(PlainListStyle())
        .navigationTitle(list.title)
        .navigationBarItems(trailing:
            Button(action: {}, label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 22))
            })
        )
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {}, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Reminder")
                    }
                    .foregroundColor(.accentColor)
                })
                Spacer()
            }
        }
    }
}

struct RemindersList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TasksView(list: TasksList(icon: "person", title: "Title", color: .green, tasks: [Task(title: "Task title", dateDue: Date(), status: .new, note: "Task note")]))
        }
    }
}
