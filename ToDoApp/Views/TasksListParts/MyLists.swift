//
//  MyLists.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 19.02.2021.
//

import SwiftUI

struct MyLists: View {
    @EnvironmentObject var provider: TasksListProvider
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Lists")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 6)
            .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                ForEach(0..<provider.lists.count) { listIndex in
//                    VStack(spacing: 0) {
//                        Spacer(minLength: 0)
//                        TasksListRow(index: listIndex, list: provider.lists[listIndex])
//                            .padding(.horizontal, 12)
//                        Spacer(minLength: 0)
//                        if (listIndex < provider.lists.count - 1) {
//                            Divider()
//                                .padding(.leading, 56)
//                        }
//                    }
//                    .frame(height: 54)
//                    .background(Color.white)
//                    .cornerRadius(
//                        listIndex == 0 || listIndex == provider.lists.count - 1 ? 10 : 0,
//                        corners:
//                            listIndex == 0 ? [.topLeft, .topRight] :
//                            listIndex == provider.lists.count - 1 ? [.bottomLeft, .bottomRight] :
//                            []
//                    )
                    TasksListRow(index: listIndex, overallQuantity: provider.lists.count, list: provider.lists[listIndex])
                }
            }
        }
    }
}

struct MyLists_Previews: PreviewProvider {
    static var previews: some View {
        MyLists()
            .environmentObject(TasksListProvider())
    }
}
