//
//  TasksListViewModel.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 21.02.2021.
//

import Foundation
import Combine

class TasksListViewModel: ObservableObject {
    enum ListColor: String {
        case red, orange, green, lightBlue, blue, gray
    }
    
    enum InsetGroupedListItemStyle {
        case top, middle, bottom, separate
    }
    
    var id: String
    var title: String
    var icon: String
    var color: ListColor
    @Published var tasks: [TaskViewModel]
    
    var count: Int {
        tasks.reduce(0, {$0 + ($1.task.status != .done ? 1 : 0)})
    }
    
    init(id: String = UUID().uuidString, title: String, icon: String = "list.bullet", color: ListColor = .lightBlue, tasks: [TaskViewModel] = []) {
        self.id = id
        self.title = title
        self.icon = icon
        self.color = color
        self.tasks = tasks
    }
    
    func someMethod() {
        print("TasksListViewModel method called")
    }
}
