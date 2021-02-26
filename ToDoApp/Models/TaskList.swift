//
//  TaskList.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 24.02.2021.
//

import Foundation

@objc class TaskList: NSObject, Identifiable, NSCoding {
    typealias ListColor = TasksListViewModel.ListColor
    var id: String
    var title: String
    var icon: String
    var color: ListColor
    var tasks: [Task]
    
    init(id: String = UUID().uuidString, title: String, icon: String, color: ListColor, tasks: [Task]) {
        self.id = id
        self.title = title
        self.icon = icon
        self.color = color
        self.tasks = tasks
    }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as! String
        title = aDecoder.decodeObject(forKey: "title") as! String
        icon = aDecoder.decodeObject(forKey: "icon") as! String
        color = ListColor(rawValue: aDecoder.decodeObject(forKey: "color") as! String) ?? .blue
        tasks = aDecoder.decodeObject(forKey: "tasks") as! [Task]
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(color.rawValue, forKey: "color")
        aCoder.encode(tasks, forKey: "tasks")
    }
}
