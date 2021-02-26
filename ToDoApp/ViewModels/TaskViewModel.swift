//
//  TaskViewModel.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 21.02.2021.
//

import Foundation
import Combine

class TaskViewModel: ObservableObject, Equatable {
    static func == (lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        lhs.task.id == rhs.task.id
    }
    
    @Published var task: Task
    @Published var toBeRemoved: Bool = false
    
    init(_ task: Task) {
        self.task = task
    }
    
    init(
        title: String? = nil,
        note: String? = nil,
        dateDue: Date? = nil,
        hasTime: Bool = false,
        status: Task.Status = .new,
        flag: Bool = false
    ) {
        self.task = Task(title: title, note: note, dateDue: dateDue, hasTime: hasTime, status: status, flag: flag)
    }
    
    func someMethod() {
        print("TaskViewModel method called")
    }
}
