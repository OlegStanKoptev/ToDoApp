//
//  TasksList.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 17.02.2021.
//

import SwiftUI

struct TasksList: Identifiable {
    let id = UUID()
    var icon: String
    var title: String
    var color: ListColor
    var tasks: [Task]
    
    enum ListColor: String {
        case red, orange, green, lightBlue, blue, grey
    }
    
    var quantity: Int {
        tasks.count
    }
}
