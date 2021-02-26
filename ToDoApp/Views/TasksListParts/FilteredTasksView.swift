//
//  FilteredTasksView.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 18.02.2021.
//

import SwiftUI

struct FilteredTasksView: View {
    @EnvironmentObject var context: AppContext
    @Environment(\.presentationMode) var presentationMode
    var title: String
    
    var body: some View {
        TasksView(list: TasksListViewModel(title: title))
    }
}

struct FilteredTasksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FilteredTasksView(title: "title")
        }
    }
}
