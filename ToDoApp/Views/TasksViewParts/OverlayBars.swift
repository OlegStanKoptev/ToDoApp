//
//  OverlayBars.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 21.02.2021.
//

import SwiftUI

struct OverlayBars: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var context: AppContext
    @Binding var topOffset: CGFloat
    @Binding var bottomOffset: CGFloat
    @Binding var showingCompletedTasks: Bool
    @Binding var editor: Bool
    
    let initialNavigationBarHeight: CGFloat = 58
    let bottomBarHeight: CGFloat = 60
    
    let largeTitleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
    
    let titleAnimationHeight: CGFloat = 144
    
    var largeTitleTopPadding: CGFloat {
        let firstPosition: CGFloat = (initialNavigationBarHeight + 6) / 2
        let secondPosition: CGFloat = initialNavigationBarHeight + 40 + 8
        let offset = topOffset > 0 ? secondPosition + topOffset * 2 :
            max(firstPosition, secondPosition + topOffset * 2)
        return offset
    }
    
    var largeTitleFontSize: CGFloat {
        let initialSize = largeTitleFont.pointSize
        var size = initialSize
        
        if (topOffset > 0) {
            let maximumSize = largeTitleFont.pointSize * 1.05
            let tempSize = initialSize + ((titleAnimationHeight + topOffset) / titleAnimationHeight - 1) * (maximumSize - initialSize)
            size = min(maximumSize, tempSize)
        }
        return size
    }
    
    var largeTitleOpacity: Double {
        topOffset <= -36 ? 0 : 1
    }
    
    var navigationBarOpacity: Double {
        var opacity: Double = 0
        if (topOffset <= 0) {
            opacity =
                min(1, 1 - Double((36 + topOffset) / 36))
        }
        return opacity
    }
    
    func backButtonPressed() {
        presentationMode.wrappedValue.dismiss()
        context.selectedList = nil
        context.editingTask = nil
    }
    
    func newReminderButtonPressed() {
        let newTask = TaskViewModel(title: "")
        context.selectedList!.tasks.append(newTask)
        context.taskForEditor = newTask
        editor = true
    }
    
    func doneButtonPressed() {
        hideKeyboard()
        // context.editingTask = nil is called by a cell
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                ZStack {
                    HStack {
                        Button(action: { backButtonPressed() }, label: {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.backward")
                                    .font(.system(size: 20, weight: .semibold))
                                Text("Lists")
                            }
                            .padding(.leading, 8)
                        })
                        Spacer()
                        Group {
                            if let _ = context.editingTask {
                                Button(action: { doneButtonPressed() }, label: {
                                    Text("Done")
                                        .bold()
                                })
//                                .opacity(context.editingTask == nil ? 0 : 1)
                            } else {
                                Menu {
//                                    Button(action: {
//                                    }) {
//                                        Label("Name & Appearance", systemImage: "pencil")
//                                    }
                                    Button(action: {
                                        withAnimation {
                                            showingCompletedTasks.toggle()
                                        }
                                    }) {
                                        Label(
                                            showingCompletedTasks ? "Hide completed" : "Show Completed",
                                            systemImage: "eye"
                                        )
                                    }
//                                    Button(action: {
//                                    }) {
//                                        Label("Delete List", systemImage: "trash")
//                                    }
                                } label: {
                                    Image(systemName: "ellipsis.circle")
                                        .font(.system(size: 21, weight: .semibold))
                                }
                            }
                        }
                        .padding(.trailing, 15)
                        .frame(height: 22)
                    }
                    .padding(.top, 14)
                    
                    Text(context.selectedList?.title ?? "nil")
                        .font(.system(.headline, design: .rounded))
                        .padding(.top, 13)
                        .opacity(topOffset <= -36 ? 1 : 0)
                        .animation(Animation.default.speed(2))
                }
            }
            .background(
                ZStack {
                    
                    HStack {
                        Text(context.selectedList?.title ?? "nil")
                            .font(.system(size: largeTitleFontSize, design: .rounded))
                            .bold()
                            .foregroundColor(Color(context.selectedList?.color.rawValue ?? TasksListViewModel.ListColor.gray.rawValue))
                        Spacer(minLength: 0)
                    }
                    .padding(.leading, 16)
                    .padding(.top, largeTitleTopPadding)
                    .opacity(largeTitleOpacity)
                    
                    Color.white
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: initialNavigationBarHeight)
                        .overlay(
                            Color("navigationBar")
                                .edgesIgnoringSafeArea(.top)
                                .overlay(
                                    VStack {
                                        Spacer()
                                        Divider()
                                    }
                                )
                                .opacity(navigationBarOpacity)
                        )
                        .opacity(topOffset >= -40 ? 1 : 0)
                    
                    BlurView()
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: initialNavigationBarHeight)
                        .overlay(
                            VStack {
                                Spacer()
                                Divider()
                            }
                        )
                        .opacity(topOffset < -40 ? 1 : 0)
                    
                }
            )
            Spacer()
            VStack {
                Spacer()
                HStack {
                    Button(action: { newReminderButtonPressed() }, label: {
                        HStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                            Text("New Reminder")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                        }
                        .padding(.leading, 14)
                        .foregroundColor(Color(context.selectedList?.color.rawValue ?? TasksListViewModel.ListColor.gray.rawValue))
                    })
                    Spacer()
                    Button(action: {}, label: {
                        EmptyView()
                    })
                }
                Spacer()
            }
            .background(
                GeometryReader { geo in
                    BlurView()
                        .edgesIgnoringSafeArea(.bottom)
                        .overlay(VStack {
                            Divider()
                            Spacer()
                        })
                        .opacity(bottomOffset - 24 > geo.frame(in: .global).origin.y ? 1 : 0)
                }
            )
            .frame(height: 44)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

