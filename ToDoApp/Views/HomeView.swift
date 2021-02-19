//
//  HomeView.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 18.02.2021.
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var provider: TasksListProvider
    @State var searchQuery = ""
    @State var enteringQuery = false
    @State var offset: CGFloat = 0
    
    let detector: CurrentValueSubject<CGFloat, Never>
    let publisher: AnyPublisher<CGFloat, Never>
    
    var bottomBarBackgroundOpacity: Double {
        let bottomLine = 448 + provider.lists.count * 54 + Int(offset)
        if offset == 0 {
            return Double(bottomLine > Int(UIScreen.main.bounds.height) ? 1 : 0)
        }
        let difference = Int(UIScreen.main.bounds.height) - bottomLine
        return difference <= 16 ? 1 : 0
    }

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
                    offsetChanged: { offset = $0.y; detector.send($0.y) }) {
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
                .onReceive(publisher) { _ in
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
            
            VStack {
                CustomNavigationBarWithSearch(offset: $offset, searchQuery: $searchQuery, enteringQuery: $enteringQuery)
                
                Spacer()
                
                if !enteringQuery {
                    HStack {
                        Button(action: {}, label: {
                            HStack(spacing: 8) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                Text("New Reminder")
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                            }
                        })
                        Spacer()
                        Button(action: {}, label: {
                            Text("Add List")
                        })
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                    .frame(height: 46)
                    .background(
                        BlurView()
                            .overlay(VStack {
                                Divider()
                                Spacer()
                            })
                            .edgesIgnoringSafeArea(.all)
                            .opacity(bottomBarBackgroundOpacity)
                    )
                    .transition(.move(edge: .bottom))
                }
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
        ZStack {
            HomeView()
                .environmentObject(TasksListProvider())
//            ForEach(verticalLines, id: \.self) { line in
//                Divider()
//                    .frame(width: UIScreen.main.bounds.width)
//                    .position(x: UIScreen.main.bounds.width / 2,
//                              y: CGFloat(line - 40))
//            }
        }
    }
}
