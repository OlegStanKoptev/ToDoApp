//
//  TaskEditorItem.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 24.02.2021.
//

import SwiftUI

struct TaskEditorItem<Content: View>: View {
    typealias RowStyle = TasksListViewModel.InsetGroupedListItemStyle
    typealias Icon = TaskEditor.Icon
    let style: RowStyle
    let icon: Icon?
    let description: String?
    var enabled: Binding<Bool>?
    let pressedAction: (() -> Void)?
    let content: Content
    
    init(style: RowStyle = .separate, icon: Icon? = nil, description: String? = nil, enabled: Binding<Bool>? = nil, pressedAction: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.style = style
        self.icon = icon
        self.description = description
        self.enabled = enabled
        self.pressedAction = pressedAction
        self.content = content()
    }
    
    @ViewBuilder
    var innerContent: some View {
        HStack(spacing: 0) {
            if let icon = icon {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(icon.color)
                    .overlay(
                        Image(systemName: icon.name)
                            .foregroundColor(.white)
                    )
                    .frame(width: 29, height: 29)
                    .padding(.trailing, 15)
                    .padding(.vertical, 14)
            }
            content
                .padding(.vertical, icon == nil ? 12 : 8)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
    }
    
    var body: some View {
        Group {
            if let pressedAction = pressedAction,
               let enabled = enabled {
                Button(action: {
                    if enabled.wrappedValue {
                        pressedAction()
                    }
                }, label: {
                    innerContent
                })
                .buttonStyle(TaskEditorButtonStyle(enabled: enabled))
            } else {
                innerContent
                    .background(Color.white)
            }
        }
        .cornerRadius(10, corners:
          style == .separate ? .allCorners :
          style == .top ? [.topLeft, .topRight] :
          style == .bottom ? [.bottomLeft, .bottomRight] : []
        )
        .overlay(
            VStack {
                Group {
                    if style == .top || style == .middle {
                        VStack {
                            Spacer()
                            Divider()
                                .padding(
                                    .leading,
                                    icon != nil ? 61 : 16
                                )
                        }
                    }
                }
            }
        )
        .padding(.horizontal, 16)
    }
}

struct TaskEditorItem_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditorItem() {
            Text("text")
        }
    }
}
