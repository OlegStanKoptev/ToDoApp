//
//  Neumorphic.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 19.02.2021.
//

import SwiftUI

struct NeumorphicButtonStyle: ButtonStyle {
    @Binding var transitioned: Bool
    var backgroundColor: Color = .white
    var overlayColor: Color = .init(.systemGray4)
    var index: Double = -1

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
                    index == 0 || index == 1 || index == -1 ? 10 : 0,
                    corners:
                        index == -1 ? .allCorners :
                        index == 0 ? [.topLeft, .topRight] :
                        index == 1 ? [.bottomLeft, .bottomRight] : []
                )
            )
    }
}

struct NoneButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
