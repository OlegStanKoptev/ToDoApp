//
//  TaskEditorButtonStyle.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 23.02.2021.
//

import SwiftUI

struct TaskEditorButtonStyle: ButtonStyle {
    @Binding var enabled: Bool
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(enabled && configuration.isPressed ? Color(.systemGray4) : Color.white)
    }
}
