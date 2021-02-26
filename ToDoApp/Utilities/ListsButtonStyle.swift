//
//  Neumorphic.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 19.02.2021.
//

import SwiftUI

struct ListsButtonStyle: ButtonStyle {
    @Binding var transitioned: Bool
    var backgroundColor: Color = .white
    var overlayColor: Color = .init(.systemGray3)
    var style: TasksListViewModel.InsetGroupedListItemStyle

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(
                ZStack {
                    backgroundColor
                    overlayColor
                        .opacity(configuration.isPressed || transitioned ? 1 : 0)
                        .transition(.opacity)
                }
                .cornerRadius(
                    10,
                    corners:
                        style == .separate ? .allCorners :
                        style == .top ? [.topLeft, .topRight] :
                        style == .bottom ? [.bottomLeft, .bottomRight] : []
                )
            )
    }
}
