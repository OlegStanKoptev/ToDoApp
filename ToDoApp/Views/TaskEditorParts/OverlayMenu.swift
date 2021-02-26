//
//  OverlayMenu.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 24.02.2021.
//

import SwiftUI

struct OverlayMenu: View {
    @EnvironmentObject var context: AppContext
    @StateObject var viewModel: TaskEditorViewModel
    @Binding var isPresented: Bool
    @Binding var topOffset: CGFloat
    let topBarHeight: CGFloat = 56
    
    var topBarOpacity: Double {
        let firstPosition: CGFloat = 0
        let secondPosition: CGFloat = 8
        
        if topOffset >= 0 { return 0 }
        else if topOffset <= -secondPosition { return 1 }
        else {
            return Double((firstPosition - topOffset) / (firstPosition + secondPosition))
        }
    }
    
    func dismiss() {
        isPresented = false
    }
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: topBarHeight)
                .overlay(
                    ZStack {
                        HStack {
                            VStack {
                                Spacer(minLength: 0)
                                Button(action: {
                                    if viewModel.cancelButtonPressed() {
                                        viewModel.discardWarningIsPresented = true
                                    } else {
                                        isPresented = false
                                        if viewModel.title.isEmpty {
                                            viewModel.taskViewModel?.wrappedValue?.toBeRemoved = true
                                        }
                                        context.taskForEditor = nil
                                    }
                                    
                                }, label: {
                                    Text("Cancel")
                                })
                                Spacer(minLength: 0)
                            }
                            Spacer()
                            VStack {
                                Spacer(minLength: 0)
                                Button(action: {
                                    viewModel.doneButtonPressed()
                                    context.taskForEditor = nil
                                    isPresented = false
                                }, label: {
                                    Text("Done")
                                        .bold()
                                })
                                Spacer(minLength: 0)
                            }
                        }
                        .padding(.horizontal, 16)
                        VStack {
                            Spacer(minLength: 0)
                            Text("Details")
                            Spacer(minLength: 0)
                        }
                        .font(.headline)
                        .foregroundColor(.primary)
                    }
                )
                .background(
                    BlurView()
                        .edgesIgnoringSafeArea(.top)
                        .overlay(
                            VStack {
                                Spacer()
                                Divider()
                            }
                        )
                        .opacity(topBarOpacity)
                )
            Spacer()
        }
    }
}


struct OverlayMenu_Previews: PreviewProvider {
    static var previews: some View {
        OverlayMenu(viewModel: TaskEditorViewModel(), isPresented: .constant(true), topOffset: .constant(0))
    }
}
