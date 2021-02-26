//
//  TaskEditor.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 22.02.2021.
//

import SwiftUI

struct TaskEditor: View {
    @EnvironmentObject var context: AppContext
    @StateObject var viewModel = TaskEditorViewModel()
    @Binding var isPresented: Bool
    @State var topOffset: CGFloat = 0
    
    var nextDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    
    var nextHour: Date {
        let zeroMinutes = Calendar.current.date(bySetting: .minute, value: 0, of: Date())!
        let zeroSeconds = Calendar.current.date(byAdding: .second, value: 0, to: zeroMinutes)!
        return Calendar.current.date(byAdding: .hour, value: 1, to: zeroSeconds)!
    }
    
    var dateText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: viewModel.chosenDate)
    }
    
    var timeText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: viewModel.chosenTime)
    }
    
    var body: some View {
        ZStack {
            CustomScrollView(
                axes: .vertical,
                showsIndicators: true,
                topOffsetChanged: { topOffset = $0 }
            ) {
                VStack(spacing: 0) {
                    Group {
                        Color.clear
                            .frame(height: 56)
                        
                        TaskEditorItem(style: .top) {
                            TextField("Title", text: $viewModel.title, onEditingChanged: { _ in }, onCommit: {})
                        }
                        
                        TaskEditorItem(style: .bottom) {
                            TextField("Notes", text: $viewModel.notes, onEditingChanged: { _ in }, onCommit: {})
                        }
                    }
                    
                    SectionSpacer()
                    
                    if viewModel.taskViewModel != nil {
                        Group {
                            TaskEditorItem(style: .top, icon: Icon(name: "calendar", color: .red), enabled: $viewModel.dateIsOn, pressedAction: {
                                withAnimation {
                                    viewModel.showingDatePicker.toggle()
                                }
                            }) {
                                VStack(alignment: .leading) {
                                    Text("Date")
                                        .foregroundColor(.primary)
                                    if viewModel.dateIsOn {
                                        Text(dateText)
                                            .font(.footnote)
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                            .overlay(
                                VStack {
                                    Spacer(minLength: 0)
                                    Toggle(isOn: $viewModel.dateIsOn, label: {})
                                        .padding(.horizontal, 32)
                                    Spacer(minLength: 0)
                                }
                            )
                            .onChange(of: viewModel.dateIsOn) { value in
                                if value {
                                    if !askForNotifications() {
                                        viewModel.dateIsOn = false
                                        return
                                    }
                                    viewModel.chosenDate = nextDay
                                }
                                if !viewModel.showingTimePicker {
                                    withAnimation {
                                        viewModel.showingDatePicker = value
                                    }
                                }
                                if !value && viewModel.timeIsOn {
                                    viewModel.timeIsOn = false
                                }
                            }


                            if viewModel.showingDatePicker {
                                TaskEditorItem(style: .middle) {
                                    DatePicker(
                                        "",
                                        selection: $viewModel.chosenDate,
                                        displayedComponents: [.date]
                                    )
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                }
                            }

                            TaskEditorItem(style: viewModel.showingTimePicker ? .middle : .bottom, icon: Icon(name: "clock.fill", color: .blue), enabled: $viewModel.timeIsOn, pressedAction: {
                                withAnimation {
                                    viewModel.showingTimePicker.toggle()
                                }
                            }) {
                                VStack(alignment: .leading) {
                                    Text("Time")
                                    if viewModel.timeIsOn {
                                        Text(timeText)
                                            .font(.footnote)
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                            .overlay(
                                VStack {
                                    Spacer(minLength: 0)
                                    Toggle(isOn: $viewModel.timeIsOn, label: {})
                                        .padding(.horizontal, 32)
                                    Spacer(minLength: 0)
                                }
                            )
                            .onChange(of: viewModel.timeIsOn) { value in
                                if value {
                                    if !askForNotifications() {
                                        viewModel.timeIsOn = false
                                        return
                                    }
                                    viewModel.chosenTime = nextHour
                                    viewModel.dateIsOn = true
                                }
                                withAnimation {
                                    viewModel.showingTimePicker = value
                                }
                                if viewModel.showingDatePicker {
                                    withAnimation {
                                        viewModel.showingDatePicker = false
                                    }
                                }
                            }

                            if viewModel.showingTimePicker {
                                TaskEditorItem(style: .bottom) {
                                    DatePicker(
                                        "",
                                        selection: $viewModel.chosenTime,
                                        displayedComponents: [.hourAndMinute]
                                    )
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                }
                            }

                            SectionSpacer()

                            TaskEditorItem(style: .separate, icon: Icon(name: "flag.fill", color: .orange)) {
                                Toggle(isOn: $viewModel.flagIsOn, label: {
                                    Text("Flag")
                                })
                            }
                            
                            SectionSpacer()
                            
                            TaskEditorItem(style: .separate) {
                                Button(action: {
                                    context.taskForEditor?.toBeRemoved = true
                                    isPresented = false
                                    context.taskForEditor = nil
                                }, label: {
                                    HStack {
                                        Spacer()
                                        Text("Delete")
                                        Spacer()
                                    }
                                    .foregroundColor(.red)
                                })
                            }
                        }
                    }
                }
            }
            
            OverlayMenu(viewModel: viewModel, isPresented: $isPresented, topOffset: $topOffset)
                .environmentObject(context)
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .actionSheet(isPresented: $viewModel.discardWarningIsPresented) {
            ActionSheet(title: Text("Are you sure?"), buttons: [
                .destructive(Text("Discard Changes"), action: {
                    isPresented = false
                    if viewModel.title.isEmpty {
                        viewModel.taskViewModel?.wrappedValue?.toBeRemoved = true
                    }
                    context.taskForEditor = nil
                }),
                .cancel({ viewModel.discardWarningIsPresented = false })
            ])
        }
        .onAppear {
            if let task = context.taskForEditor?.task {
                viewModel.title = task.title ?? "nil"
                viewModel.notes = task.note ?? ""
                if let dateDue = task.dateDue {
                    viewModel.dateIsOn = true
                    viewModel.chosenDate = dateDue
                    if task.hasTime {
                        viewModel.timeIsOn = true
                        viewModel.chosenTime = dateDue
                    }
                }
                viewModel.flagIsOn = task.flag
                
                viewModel.setTaskViewModel(model: $context.taskForEditor)
            } else {
                viewModel.title = "error"
            }
            viewModel.setEditorIsPresented(presented: $isPresented)
        }
    }
    
    func askForNotifications() -> Bool {
        var allowed: Bool = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
                allowed = false
            }
        }
        return allowed
    }
    
    struct SectionSpacer: View {
        var body: some View {
            Color.clear
                .frame(height: 18)
        }
    }
    
    struct Icon {
        let name: String
        let color: Color
    }
}

struct TaskEditor_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditor(isPresented: .constant(true))
            .environmentObject(MockTaskEditingAppContext() as AppContext)
    }
}
