//
//  CustomNavigationBarWithSearch.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 19.02.2021.
//

import SwiftUI

struct CustomNavigationBarWithSearch: View {
    @Binding var offset: CGFloat
    @Binding var searchQuery: String
    @Binding var enteringQuery: Bool
    
    var chinHeight: CGFloat {
        offset >= -36 ? 16 : max(-1, 36 + 16 + offset)
    }
    
    var navBarBackgroundOpacity: CGFloat {
        offset >= 0 ? 1 : max(0, (36 + 16 + offset) / (36 + 16))
    }
    
    var bottomBarBackgroundOpacity: CGFloat {
        1.0
    }
    
    var body: some View {
        VStack(spacing: 13) {
            if !enteringQuery && searchQuery.isEmpty {
                HStack {
                    Spacer()
                    Button(action: {}, label: {
                        Text("Edit")
                    })
                    .opacity(0)
                }
                .transition(.opacity)
                .padding(.horizontal, 16)
            }
            SearchBar(query: $searchQuery, editing: $enteringQuery, offset: $offset)
        }
        .padding(.top, 16)
        .padding(.bottom, chinHeight)
        .background(
            ZStack {
                if Double(navBarBackgroundOpacity) == 1 {
                    Rectangle()
                        .edgesIgnoringSafeArea(.all)
                        .foregroundColor(.init(.systemGray6))
                }
                BlurView()
                    .edgesIgnoringSafeArea(.top)
                    .overlay(
                        VStack(spacing: 0) {
                            Spacer()
                            Divider()
                        }
                    )
                    .opacity(
                        enteringQuery || !searchQuery.isEmpty ? 1 :
                            1 - Double(navBarBackgroundOpacity)
                    )
            }
        )
    }
}


struct CustomNavigationBarWithSearch_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBarWithSearch(offset: .constant(0), searchQuery: .constant(""), enteringQuery: .constant(false))
    }
}
