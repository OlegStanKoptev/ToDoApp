//
//  Task.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 17.02.2021.
//

import Foundation

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var dateDue: Date
    var status: Status
    var note: String
    
    enum Status {
        case new, done
    }
}
