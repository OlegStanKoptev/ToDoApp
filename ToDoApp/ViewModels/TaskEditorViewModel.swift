//
//  TaskEditorViewModel.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 24.02.2021.
//

import SwiftUI

class TaskEditorViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var notes: String = ""
    
    @Published var dateIsOn: Bool = false
    @Published var showingDatePicker: Bool = false
    @Published var chosenDate: Date = Date()
    
    @Published var timeIsOn: Bool = false
    @Published var showingTimePicker: Bool = false
    @Published var chosenTime: Date = Date()
    
    @Published var flagIsOn: Bool = false
    
    @Published var discardWarningIsPresented: Bool = false
    
    var editorIsPresented: Binding<Bool>? = nil
    
    var taskViewModel: Binding<TaskViewModel?>? = nil
    
    func setTaskViewModel(model: Binding<TaskViewModel?>) {
        self.taskViewModel = model
    }
    
    func setEditorIsPresented(presented: Binding<Bool>) {
        self.editorIsPresented = presented
    }
    
    func cancelButtonPressed() -> Bool {
        var changesMade = false
        if let taskViewModelBinding = taskViewModel {
            if let task = taskViewModelBinding.wrappedValue?.task {
                if let taskTitle = task.title {
                    changesMade = changesMade || title != taskTitle
                } else {
                    changesMade = changesMade || title != ""
                }
                if let taskNotes = task.note {
                    changesMade = changesMade || notes != taskNotes
                } else {
                    changesMade = changesMade || notes != ""
                }
                if let taskDateDue = task.dateDue {
                    changesMade = changesMade || dateIsOn != true || chosenDate != taskDateDue
                } else {
                    changesMade = changesMade || dateIsOn != false
                }
                if task.hasTime {
                    changesMade = changesMade || timeIsOn != true || chosenTime != task.dateDue!
                }
                changesMade = changesMade || flagIsOn != task.flag
            }
        }
        return changesMade
    }
    
    func doneButtonPressed() {
        if let _ = taskViewModel?.wrappedValue {
            if title.isEmpty {
                taskViewModel!.wrappedValue?.task.title = nil
                taskViewModel!.wrappedValue?.toBeRemoved = true
            } else {
                taskViewModel!.wrappedValue?.task.title = title
            }
            taskViewModel!.wrappedValue?.task.note = notes.isEmpty ? nil : notes
            if dateIsOn {
                taskViewModel!.wrappedValue?.task.dateDue = chosenDate
            } else {
                taskViewModel!.wrappedValue?.task.dateDue = nil
            }
            if timeIsOn {
                taskViewModel!.wrappedValue?.task.hasTime = true
                let components = Calendar.current.dateComponents([.hour, .minute, .second], from: chosenTime)
                let combinedDate = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: components.second!, of: chosenDate)
                taskViewModel!.wrappedValue?.task.dateDue = combinedDate
            } else {
                taskViewModel!.wrappedValue?.task.hasTime = false
            }
            taskViewModel!.wrappedValue?.task.flag = flagIsOn
        }
    }
    
    func addNewReminder() {
        
    }
}
