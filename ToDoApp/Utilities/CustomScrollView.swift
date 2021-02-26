//
//  CustomScrollView.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 18.02.2021.
//

import SwiftUI

struct CustomScrollView<Content: View>: View {
    let axes: Axis.Set
    let showsIndicators: Bool
    let topOffsetChanged: (CGFloat) -> Void
    let bottomOffsetChanged: (CGFloat) -> Void
    let content: Content

    init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        topOffsetChanged: @escaping (CGFloat) -> Void = { _ in },
        bottomOffsetChanged: @escaping (CGFloat) -> Void = { _ in },
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.topOffsetChanged = topOffsetChanged
        self.bottomOffsetChanged = bottomOffsetChanged
        self.content = content()
    }
    
    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            GeometryReader { geometry1 in
                Color.clear
                    .preference(
                        key: ScrollOffsetTopPreferenceKey.self,
                        value: geometry1.frame(in: .named("scrollView")).origin.y
                    )
            }.frame(width: 0, height: 0)
            .onPreferenceChange(ScrollOffsetTopPreferenceKey.self, perform: topOffsetChanged)
            content
            
            GeometryReader { geometry2 in
                Color.clear
                    .preference(
                        key: ScrollOffsetBottomPreferenceKey.self,
                        value: geometry2.frame(in: .named("scrollView")).origin.y
                    )
            }.frame(width: 0, height: 0)
            .onPreferenceChange(ScrollOffsetBottomPreferenceKey.self, perform: bottomOffsetChanged)
        }
        .coordinateSpace(name: "scrollView")
    }
}

private struct ScrollOffsetTopPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

private struct ScrollOffsetBottomPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
