//
//  FilteredTasksView.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 18.02.2021.
//

import SwiftUI

struct FilteredTasksView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var list: TasksList
    
    var body: some View {
        TasksView(list: list)
            .accentColor(Color(list.color.rawValue))
    }
}

struct FilteredTasksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FilteredTasksView(list: TasksList(icon: "person", title: "Title", color: .blue, tasks: []))
        }
    }
}
