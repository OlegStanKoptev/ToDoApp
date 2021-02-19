//
//  RemindersListProvider.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 17.02.2021.
//

import Foundation
import Combine

class TasksListProvider: ObservableObject {
    @Published var lists: [TasksList]
    init(_ lists: [TasksList] = [
        TasksList(icon: "list.bullet", title: "Reminders", color: .lightBlue, tasks: [
            Task(title: "Title 1", dateDue: Date(), status: .new, note: ""),
            Task(title: "Title 2", dateDue: Date(), status: .new, note: "Note 1"),
            Task(title: "Title 3", dateDue: Date(), status: .done, note: "note note note note note note note note note note note note note note note note note note note note note note note note note note note")
        ]),
        TasksList(icon: "cart", title: "Shopping List", color: .green, tasks: []),
        TasksList(icon: "graduationcap.fill", title: "To Learn", color: .orange, tasks: []),
        TasksList(icon: "pills", title: "Medicine", color: .red, tasks: []),
        TasksList(icon: "studentdesk", title: "University", color: .blue, tasks: []),
        TasksList(icon: "cart", title: "Shopping List", color: .green, tasks: []),
        TasksList(icon: "graduationcap.fill", title: "To Learn", color: .orange, tasks: []),
        TasksList(icon: "pills", title: "Medicine", color: .red, tasks: []),
//        TasksList(icon: "studentdesk", title: "University", color: .blue, tasks: []),
//        TasksList(icon: "cart", title: "Shopping List", color: .green, tasks: []),
//        TasksList(icon: "graduationcap.fill", title: "To Learn", color: .orange, tasks: []),
//        TasksList(icon: "pills", title: "Medicine", color: .red, tasks: []),
//        TasksList(icon: "studentdesk", title: "University", color: .blue, tasks: []),
    ]) {
        self.lists = lists
    }
    var overallCount: Int {
        var counter = 0
        lists.forEach({ list in counter += list.quantity })
        return counter
    }
}
