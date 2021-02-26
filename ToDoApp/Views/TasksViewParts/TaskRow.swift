//
//  TaskRow.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 17.02.2021.
//

import SwiftUI

struct TaskRow: View {
    @EnvironmentObject var context: AppContext
    var list: TasksListViewModel
    @Binding var editor: Bool
    @State var taskViewModel: TaskViewModel
    @State var title = ""
    @State var done: Bool?
    @Binding var isResponder: Bool?
    var disableEditing = false
    
    var dateTime: String {
        var output = ""
        
        if let dateDue = taskViewModel.task.dateDue {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = taskViewModel.task.hasTime ? .short : .none
            output = dateFormatter.string(from: dateDue)
            if taskViewModel.task.note != nil {
                output.append("\n")
            }
        }
        
        return output
    }
    
    var descriptionColor: Color {
        if let dateDue = taskViewModel.task.dateDue {
            let now = Date()
            return now < dateDue ? .secondary : .init("red")
        } else {
            return .secondary
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 10) {
                Group {
                    if disableEditing || done != nil && done! {
                        HStack {
                            Group {
                                if let done = done, done {
                                    Text(title)
                                        .strikethrough()
                                        .foregroundColor(.secondary)
                                } else {
                                    Text(title)
                                }
                            }
                            .font(.system(.body, design: .rounded))
                            Spacer(minLength: 0)
                        }
                    } else {
                        CustomTextField(text: $title, nextResponder: .constant(nil), isResponder: $isResponder, keyboard: .default) {
                            // didStartEditing
                            context.editingTask = taskViewModel
                        } didEndEditingHandler: {
                            // didEndEditing
                            if title == "" {
                                context.editingTask?.toBeRemoved = true
                                context.editingTask = nil
                            } else {
                                context.editingTask?.task.title = title
                                context.editingTask = nil
                            }
                        }
                    }
                }
                .frame(height: 36)
                
                if taskViewModel.task.note != nil && taskViewModel.task.note != "" || taskViewModel.task.dateDue != nil {
                    HStack {
                        Text(dateTime + (taskViewModel.task.note ?? ""))
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(descriptionColor)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(4)
                            .padding(.top, -12)
                            .padding(.bottom, 4)
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.top, 2)
            .padding(.bottom, 6)
            .padding(.leading, 52)
            .padding(.trailing, taskViewModel.task.flag ? 42 : 16)
            .padding(.trailing, context.editingTask == taskViewModel ? 32 : 0)
            .padding(.trailing, done != nil && done! ? 32 : 0)
            .onTapGesture {
                isResponder = true
            }
            
            VStack {
                HStack {
                    ZStack {
                        Circle()
                            .stroke(done ?? false ? Color(list.color.rawValue) : Color.gray)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                        Circle()
                            .fill(Color(list.color.rawValue))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                            .opacity(done ?? false ? 1 : 0)
                    }
                    .onTapGesture {
                        withAnimation {
                            context.editingTask = taskViewModel
                            done?.toggle()
                            taskViewModel.task.status = taskViewModel.task.status == .new ? .done : .new
                            context.editingTask = nil
                        }
                        hideKeyboard()
                    }
                    Spacer()
                    if taskViewModel.task.flag {
                        Image(systemName: "flag.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                    }
                    
                    if !disableEditing, let done = done, done {
                        Button(action: {
                            withAnimation {
                                context.editingTask = taskViewModel
                                taskViewModel.toBeRemoved = true
                                context.editingTask = nil
                            }
                        }, label: {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 6)
                        })
                    }
                    
                    if !disableEditing && context.editingTask == taskViewModel {
                        Button(action: {
                            hideKeyboard()
                            context.taskForEditor = taskViewModel
                            editor = true
                        }, label: {
                            Image(systemName: "info.circle")
                                .font(.system(size: 20))
                                .foregroundColor(Color(context.selectedList?.color.rawValue ?? "blue"))
                        })
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)
            }
            
            
        }
        .overlay(VStack { Spacer(); Divider().padding(.leading, 52) })
        .onAppear {
            title = taskViewModel.task.title ?? ""
            done = taskViewModel.task.status == .done
        }
        .onChange(of: editor) { value in
            title = taskViewModel.task.title ?? "error"
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var context: AppContext = MockListAppContext()
    static var previews: some View {
        TaskRow(list: context.selectedList!, editor: .constant(false), taskViewModel: context.lists[0].tasks[0], isResponder: .constant(false))
            .environmentObject(context)
            .previewLayout(.sizeThatFits)
    }
}
