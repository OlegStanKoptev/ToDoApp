//
//  SearchBar.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 18.02.2021.
//

import SwiftUI

struct SearchBar: View {
    @Binding var query: String
    @Binding var editing: Bool
    @Binding var offset: CGFloat
    
    var barHeight: CGFloat {
        offset >= 0 ? 36 : max(0, 36 + offset)
    }
    
    var textOpacity: CGFloat {
        offset >= 0 ? 1 : max(0, (6 + offset) / 6)
    }
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("searchBar"))
                .frame(height: editing || !query.isEmpty ? 36 : barHeight)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.init(.systemGray2))
                            .padding(.leading, 8)
                        TextField("Search", text: $query, onEditingChanged: { isEditing in
                                withAnimation {
                                    editing = isEditing
                                }
                            }, onCommit: { print("search commit") })
                        if (!query.isEmpty) {
                            Button(action: {
                                self.query = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                    .opacity(editing || !query.isEmpty ? 1 : Double(textOpacity))
                )
                .padding(.horizontal, 4)
            
            if editing || !query.isEmpty {
                Button(action: {
                    withAnimation {
                        self.editing = false
                    }
                    self.query = ""
                    hideKeyboard()
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 4)
                .transition(.move(edge: .trailing))
                .animation(.easeInOut)
            }
        }
        .padding(.horizontal, 12)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(query: .constant("1234"), editing: .constant(true), offset: .constant(0))
    }
}
