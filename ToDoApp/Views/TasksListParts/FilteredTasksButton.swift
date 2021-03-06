//
//  FilteredTasksButton.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 17.02.2021.
//

import SwiftUI

struct FilteredTasksButton: View {
    @EnvironmentObject var context: AppContext
    var label: String
    var icon: String
    var color: TasksListViewModel.ListColor
    var counter: Int
    @State var activeTransition = false
    var body: some View {
//        NavigationLink(
//            destination: FilteredTasksView(title: label).environmentObject(context),
//            isActive: $activeTransition,
//            label: {
        Button(action: {}, label: {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color(color.rawValue))
                            .overlay(
                                Image(systemName: icon)
                                    .foregroundColor(.white)
                            )
                        Spacer(minLength: 0)
                        Text("\(counter)").font(.system(size: 28, weight: .bold, design: .rounded))
                            .padding(.trailing, 4)
                    }
                    
                    Text(label)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(height: 82)
            }
        )
        .buttonStyle(ListsButtonStyle(transitioned: $activeTransition, style: .separate))
    }
}

struct FilteredTasksButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GeometryReader { _ in
                VStack {
                    Spacer()
                    FilteredTasksButton(label: "Today", icon: "house", color: .blue, counter: 1)
                    Spacer()
                }
            }
            .background(Color.gray)
        }
    }
}
