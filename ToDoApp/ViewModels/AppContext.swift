//
//  AppContext.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 21.02.2021.
//

import Foundation
import SwiftUI

class AppContext: ObservableObject {
    // MARK: Private fields
    private let defaults: UserDefaults = UserDefaults.standard
    private let sharedDefault = UserDefaults(suiteName: "group.com.koptev.ToDoApp")!
    private let storageName: String = "SavedReminders"
    
    // MARK: Published properties with observers
    @Published var lists: [TasksListViewModel]
    @Published var selectedList: TasksListViewModel? // {
//        didSet {
//            if let selectedList = selectedList {
//                print("selected list \(selectedList.title)")
//            } else if let oldValue = oldValue {
//                print("left the list \(oldValue.title)")
//            }
//        }
//    }
    @Published var editingTask: TaskViewModel? {
        didSet {
            //TODO: Save new data to UserDefaults
            if let _ = editingTask {
//                print("editing task \(String(describing: editingTask.task.title))")
            } else if let oldValue = oldValue {
//                print("finished editing task \(String(describing: oldValue.task.title))")
                if oldValue.toBeRemoved {
//                    print("removing \(String(describing: oldValue.task.title))...")
                    guard let selectedList = selectedList else { print("error: selectedList is nil"); return }
                    selectedList.tasks.removeAll(where: { $0.task.id == oldValue.task.id })
//                    print("succesfully removed \(String(describing: oldValue.task.title))!")
                    
                }
                if oldValue.toBeRemoved || oldValue.task.status == .done,
                   let dateDue = oldValue.task.dateDue {
                    removeOldNotification(oldValue.task.id, dateDue: dateDue)
                }
                saveData()
                updateBadge()
            }
        }
    }
    
    @Published var taskForEditor: TaskViewModel? {
        didSet {
            if let _ = taskForEditor {
//                print("started editor for task \(String(describing: taskForEditor.task.title))")
            } else if let oldValue = oldValue {
//                print("finished editor for task \(String(describing: oldValue.task.title)). Saving info...")
                if oldValue.toBeRemoved {
//                    print("removing \(String(describing: oldValue.task.title))...")
                    guard let selectedList = selectedList else { print("error: selectedList is nil"); return }
                    selectedList.tasks.removeAll(where: { $0.task.id == oldValue.task.id })
                    
                    if let dateDue = oldValue.task.dateDue {
                        removeOldNotification(oldValue.task.id, dateDue: dateDue)
                    }
                    
//                    print("succesfully removed \(String(describing: oldValue.task.title))!")
                } else if let dateDue = oldValue.task.dateDue {
                    let content = UNMutableNotificationContent()
                    content.title = oldValue.task.title ?? "nil"
                    content.subtitle = oldValue.task.note ?? ""
                    content.sound = UNNotificationSound.default

//                    print("creating new notification")
                    
                    var date = Date()
                    if oldValue.task.hasTime {
                        date = dateDue
                    } else {
                        date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: dateDue)!
                    }
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)
                    
                    
                    removeOldNotification(oldValue.task.id, dateDue: dateDue)
                    
                    let request = UNNotificationRequest(identifier: oldValue.task.id, content: content, trigger: trigger)

                    UNUserNotificationCenter.current().add(request)
                }
                saveData()
                updateBadge()
            }
        }
    }
    
    // MARK: Initializers
    init() {
        lists = []
        
        if !loadData() {
            lists = [
               TasksListViewModel(title: "Reminders"),
               TasksListViewModel(title: "Shopping List", icon: "cart", color: .green),
               TasksListViewModel(title: "To Learn", icon: "graduationcap.fill", color: .orange),
               TasksListViewModel(title: "Medicine", icon: "pills", color: .red),
               TasksListViewModel(title: "University", icon: "studentdesk", color: .blue),
           ]
        }
        
        updateBadge()
        fetchNewReminders()
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil, using: { _ in self.fetchNewReminders() })
    }
    
    init(_ lists: [TasksListViewModel]) {
        self.lists = lists
    }
    
    // MARK: Properties
    var tasksCount: Int {
        lists.reduce(0) { (Result, TasksListViewModel) -> Int in
            Result + TasksListViewModel.tasks.reduce(0) {
                $0 + ($1.task.status != .done ? 1 : 0)
            }
        }
    }
    
    var tasksList: [TaskViewModel] {
        lists.flatMap({model in model.tasks})
    }
    
    // MARK: Methods
    func updateBadge() {
        let now = Date()
        let amountOfPassedDeadlines = lists.reduce(0, {$0 + $1.tasks.reduce(0, { (res, task) in
            if let dateDue = task.task.dateDue {
                return res + (task.task.status == .new && now > dateDue ? 1 : 0)
            }
            return res
        })})
        UIApplication.shared.applicationIconBadgeNumber = amountOfPassedDeadlines
    }
    
    func getRawRemindersData() -> [TaskList] {
        var result: [TaskList] = []
        for list in lists {
            var tasks: [Task] = []
            for taskModel in list.tasks {
                tasks.append(taskModel.task)
            }
            result.append(TaskList(id: list.id, title: list.title, icon: list.icon, color: list.color, tasks: tasks))
        }
        return result
    }
    
    func setRawRemindersData(_ data: [TaskList]) {
        lists = []
        for list in data {
            var tasks: [TaskViewModel] = []
            for task in list.tasks {
                tasks.append(TaskViewModel(task))
            }
            lists.append(TasksListViewModel(id: list.id, title: list.title, icon: list.icon, color: list.color, tasks: tasks))
        }
    }
    
    func saveData() {
        let encodedData = try! NSKeyedArchiver.archivedData(withRootObject: getRawRemindersData(), requiringSecureCoding: false)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: storageName)
    }
    
    func loadData() -> Bool {
        if let decoded = UserDefaults.standard.object(forKey: storageName) as? Data {
            let decodedData = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [TaskList]
            setRawRemindersData(decodedData)
            return true
        }
        return false
    }
    
    func removeOldNotification(_ id: String, dateDue: Date) {
        if Date() > dateDue {
            print("removing delivered notification")
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
        } else {
            print("removing pending notification")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
    }
    
    func fetchNewReminders() {
        let originLists = lists
        let newReminders = sharedDefault.object(forKey: "remindersFromShareSheet") as? [String]
        if let newReminders = newReminders {
            for task in newReminders {
                originLists.first!.tasks.append(TaskViewModel(title: task, note: nil, dateDue: nil, hasTime: false, status: .new, flag: false))
            }
        }
        sharedDefault.set([], forKey: "remindersFromShareSheet")
        lists = originLists
        saveData()
    }
}

// MARK: Mock contexts for preview screens
class MockListAppContext: AppContext {
    override init() {
        super.init()
        lists = [
            TasksListViewModel(title: "Reminders", tasks: [ TaskViewModel(title: "Напоминание 1", status: .done) ]),
            TasksListViewModel(title: "Shopping List", icon: "cart", color: .green, tasks: [
                TaskViewModel(title: "Напоминание 1"),
                TaskViewModel(title: "Напоминание 2", note: "Заметка"),
                TaskViewModel(title: "Напоминание 3", note: "Заметка на две строчки слова слова слова слова"),
                TaskViewModel(title: "Напоминание 4", dateDue: DateComponents(calendar: Calendar.current, year: 2021, month: 2, day: 21).date),
                TaskViewModel(title: "Напоминание 5", dateDue: DateComponents(calendar: Calendar.current, year: 2021, month: 2, day: 21, hour: 19).date, hasTime: true),
                TaskViewModel(title: "Напоминание 6", flag: true),
                TaskViewModel(title: "Напоминание 1"),
                TaskViewModel(title: "Напоминание 2", note: "Заметка"),
                TaskViewModel(title: "Напоминание 3", note: "Заметка на две строчки слова слова слова слова"),
                TaskViewModel(title: "Напоминание 4", dateDue: DateComponents(calendar: Calendar.current, year: 2021, month: 2, day: 21).date),
                TaskViewModel(title: "Напоминание 5", dateDue: DateComponents(calendar: Calendar.current, year: 2021, month: 2, day: 21, hour: 19).date, hasTime: true),
                TaskViewModel(title: "Напоминание 6", flag: true),
            ]),
            TasksListViewModel(title: "To Learn", icon: "graduationcap.fill", color: .orange),
            TasksListViewModel(title: "Medicine", icon: "pills", color: .red),
            TasksListViewModel(title: "University", icon: "studentdesk", color: .blue),
        ]
        selectedList = lists[1]
    }
}

class MockTaskAppContext: MockListAppContext {
    override init() {
        super.init()
        editingTask = selectedList!.tasks[0]
    }
}

class MockTaskEditingAppContext: MockListAppContext {
    override init() {
        super.init()
        taskForEditor = selectedList!.tasks[0]
    }
}
