//
//  HomeView.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 18.02.2021.
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var context: AppContext
    @State var searchQuery = ""
    @State var enteringQuery = false
    @State var topOffset: CGFloat = 0
    @State var bottomOffset: CGFloat = 0
    @State var bottomSafeAreaHeight: CGFloat = 0
    
    let detector: CurrentValueSubject<CGFloat, Never>
    let publisher: AnyPublisher<CGFloat, Never>
    
    init() {
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.publisher = detector
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
        self.detector = detector
    }
    
    var body: some View {
        ZStack {
            ScrollViewReader { scrollViewProxy in
                CustomScrollView(
                    axes: .vertical,
                    showsIndicators: false,
                    topOffsetChanged: { topOffset = $0; detector.send($0) },
                    bottomOffsetChanged: { bottomOffset = $0 }) {
                    Color.clear
                        .frame(height: enteringQuery ? 10 : 37)
                        .id(0)
                    
                    TopFilteredLists()
                        .padding(.top, 63)
                        .id(1)
                    
                    MyLists()
                    
                    Color.clear
                        .frame(height: 50)
                }
                .onReceive(publisher) { offset in
                    withAnimation {
                        if offset < 0 && offset >= -30 {
                            scrollViewProxy.scrollTo(0, anchor: .bottom)
                        } else if offset < -30 && offset > -70 {
                            scrollViewProxy.scrollTo(1, anchor: .top)
                        }
                    }
                }
                .overlay(
                    Rectangle()
                        .edgesIgnoringSafeArea(.bottom)
                        .padding(.horizontal, -16)
                        .foregroundColor(enteringQuery ? Color.black.opacity(0.1) : .clear)
                )
                .padding(.horizontal, 16)
            }
            
            VStack(spacing: 0) {
                CustomNavigationBarWithSearch(offset: $topOffset, searchQuery: $searchQuery, enteringQuery: $enteringQuery)
                
                if !searchQuery.isEmpty {
                    SearchResult(searchQuery: $searchQuery, enteringQuery: $enteringQuery)
                }
                
                Spacer()
                
//                if !enteringQuery {
//                    HStack {
//                        Button(action: { }, label: {
//                            HStack(spacing: 8) {
//                                Image(systemName: "plus.circle.fill")
//                                    .font(.system(size: 26, weight: .bold, design: .rounded))
//                                Text("New Reminder")
//                                    .font(.system(size: 17, weight: .bold, design: .rounded))
//                            }
//                        })
//                        Spacer()
//                        Button(action: { }, label: {
//                            Text("Add List")
//                        })
//                    }
//                    .padding(.top, 10)
//                    .padding(.horizontal, 16)
//                    .frame(height: 46)
//                    .background(
//                        GeometryReader { geo in
//                            BlurView()
//                                .overlay(VStack {
//                                    Divider()
//                                    Spacer()
//                                })
//                                .edgesIgnoringSafeArea(.all)
//                                .opacity(bottomOffset - 14 > geo.frame(in: .global).origin.y ? 1 : 0)
//                        }
//                    )
//                    .transition(.move(edge: .bottom))
//                }
            }
            .ignoresSafeArea(.keyboard, edges: .all)
        }
        .background(
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
        )
        .navigationTitle("Lists")
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static let verticalLines: [Int] = [
        40, 59, 72, 89, 100, 114, 125, 156, 167, 198, 214, 226, 238, 254, 312, 324, 336, 353, 369, 382, 436, 490, 545, 599, 653, 708, 728, 750, 762
    ]
    static var previews: some View {
        NavigationView {
            ZStack {
                HomeView()
                    .environmentObject(AppContext())
//            ForEach(verticalLines, id: \.self) { line in
//                Divider()
//                    .frame(width: UIScreen.main.bounds.width)
//                    .position(x: UIScreen.main.bounds.width / 2,
//                              y: CGFloat(line - 40))
//            }
            }
        }
    }
}

struct SearchResult: View {
    @EnvironmentObject var context: AppContext
    @Binding var searchQuery: String
    @Binding var enteringQuery: Bool
    var body: some View {
        CustomScrollView(axes: .vertical, showsIndicators: true, topOffsetChanged: { _ in }, bottomOffsetChanged: { _ in }) {
            ForEach(context.lists, id: \.id) { list in
                if list.tasks.count != 0 &&
                    list.tasks.contains(where: { task in task.task.title!.lowercased().contains(searchQuery.lowercased().trimmingCharacters(in: .whitespaces)) ||
                                            task.task.note != nil &&
                                            task.task.note!.lowercased().contains(searchQuery.lowercased().trimmingCharacters(in: .whitespaces)) })
                {
                    HStack {
                        Text(list.title)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color(list.color.rawValue))
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 16)
                    ForEach(list.tasks, id: \.task.id) { taskViewModel in
                        Group {
                            if taskViewModel.task.title!.lowercased().contains(searchQuery.lowercased().trimmingCharacters(in: .whitespaces)) ||
                                taskViewModel.task.note != nil &&
                                taskViewModel.task.note!.lowercased().contains(searchQuery.lowercased().trimmingCharacters(in: .whitespaces)) {
                                TaskRow(list: list, editor: .constant(false), taskViewModel: taskViewModel, isResponder: .constant(false), disableEditing: true)
                            }
                        }
                    }
                }
            }
            
            
        }
        .background(Color.white)
    }
}
