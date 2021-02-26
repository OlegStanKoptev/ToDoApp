//
//  TopFilteredLists.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 19.02.2021.
//

import SwiftUI

struct TopFilteredLists: View {
    @EnvironmentObject var context: AppContext
    var todayIconName: Int {
        Calendar.current.dateComponents([.day], from: Date()).day!
    }
    var body: some View {
//        VStack(spacing: 16) {
//            HStack(spacing: 16) {
//                FilteredTasksButton(label: "Today", icon: "\(todayIconName).square", color: .blue, counter: 0)
//                FilteredTasksButton(label: "Scheduled", icon: "calendar", color: .red, counter: 0)
//            }
            FilteredTasksButton(label: "All", icon: "tray.fill", color: .gray, counter: context.tasksCount)
//        }
    }
}


struct TopFilteredLists_Previews: PreviewProvider {
    static var previews: some View {
        TopFilteredLists()
            .environmentObject(AppContext())
    }
}
