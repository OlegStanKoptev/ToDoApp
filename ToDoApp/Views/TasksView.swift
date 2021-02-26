//
//  TasksView.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 17.02.2021.
//

import SwiftUI

struct TasksView: View {
    @EnvironmentObject var context: AppContext
    var list: TasksListViewModel
    @State var showingTaskEditor: Bool = false
    @State var showingCompletedTasks: Bool = false
    @State var topOffset: CGFloat = 0
    @State var bottomOffset: CGFloat = 0
    var body: some View {
        ZStack {
            CustomScrollView(
                axes: .vertical,
                showsIndicators: true,
                topOffsetChanged: { topOffset = $0 },
                bottomOffsetChanged: { bottomOffset = $0 }
            ) {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 92)
                    
                    ForEach(list.tasks, id: \.task.id) { task in
                        if task.task.status != .done {
                            TaskRow(list: list, editor: $showingTaskEditor, taskViewModel: task, isResponder: Binding(.constant(false)))
                        }
                    }
                    
                    if showingCompletedTasks {
                        ForEach(list.tasks, id: \.task.id) { task in
                            if task.task.status == .done {
                                TaskRow(list: list, editor: $showingTaskEditor, taskViewModel: task, isResponder: Binding(.constant(false)))
                            }
                        }
                    }
                    
                    Color.clear
                        .frame(height: 60)
                }
            }
            
            OverlayBars(topOffset: $topOffset, bottomOffset: $bottomOffset, showingCompletedTasks: $showingCompletedTasks, editor: $showingTaskEditor)
                .environmentObject(context)
            
        }
        .navigationBarHidden(true)
        .onAppear {
            context.selectedList = list
        }
        .sheet(isPresented: $showingTaskEditor) {
            TaskEditor(isPresented: $showingTaskEditor)
                .environmentObject(context)
        }
    }
}

struct RemindersList_Previews: PreviewProvider {
    static let context: AppContext = MockListAppContext()
    static let horizontalLines: [CGFloat] = [
//        55, 57, 59, 72, 75, 77, 88, 99, 106, 124, 140
//        140, 148, 167, 172, 184, 193, 199, 211, 216, 223, 234, 248
//        728, 744, 750, 753, 762, 768
//        88
//        140
//        728
    ]
    static let verticalLines: [CGFloat] = [
//        9, 18, 20, 31, 64, 179, 336, 358
//        16, 40, 53, 166
//        146, 187, 188, 228
    ]
    static var previews: some View {
        NavigationView {
            ZStack {
                TasksView(list: context.selectedList!)
                    .environmentObject(context)
                ForEach(horizontalLines, id: \.self) { y in
                    Divider()
                        .position(x: UIScreen.main.bounds.width / 2, y: y - 40)
                }
                ForEach(verticalLines, id: \.self) { x in
                    HStack {
                        Divider()
                            .frame(height: UIScreen.main.bounds.height)
                            .position(x: x, y: UIScreen.main.bounds.height / 2)
                    }
                }
            }
        }
    }
}
