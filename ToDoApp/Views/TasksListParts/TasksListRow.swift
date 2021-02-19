//
//  TasksListRow.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 17.02.2021.
//

import SwiftUI

struct TasksListRow: View {
    @State var activeTransition = false
    var index: Int
    var overallQuantity: Int
    var list: TasksList
    var body: some View {
        NavigationLink(
            destination: TasksView(list: list)
                .accentColor(Color(list.color.rawValue)),
            isActive: $activeTransition,
            label: {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 0) {
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color(list.color.rawValue))
                            .overlay(
                                Image(systemName: list.icon)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        Text(list.title)
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .foregroundColor(.primary)
                            .padding(.leading, 12)
                        Spacer(minLength: 0)
                        Text("\(list.quantity)")
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                            .padding(.trailing, 9)
                        Image(systemName: "chevron.forward")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(.systemGray3))
                            .padding(.trailing, 4)
                    }
                    .padding(.top, 6)
                    .padding(.bottom, 4)
                    .padding(.horizontal, 12)
                    
                    Spacer(minLength: 0)
                    if (index < overallQuantity - 1) {
                        Divider()
                            .padding(.leading, 56)
                    }
                }
                .frame(height: 54)
            }
        )
        .buttonStyle(NeumorphicButtonStyle(transitioned: $activeTransition, index: Double(index) / Double(overallQuantity - 1)))
    }
}

struct RemindersListRow_Previews: PreviewProvider {
    static var previews: some View {
        TasksListRow(index: 0, overallQuantity: 5, list: TasksList(icon: "house", title: "Title", color: .blue, tasks: []))
    }
}
