//
//  MyLists.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 19.02.2021.
//

import SwiftUI

struct MyLists: View {    
    @EnvironmentObject var context: AppContext
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
                ForEach(0..<context.lists.count) { listIndex in
                    TasksListRow(
                        list: context.lists[listIndex],
                        style: listIndex == 0 ? .top :
                            listIndex < context.lists.count - 1 ? .middle :
                            .bottom)
                        .environmentObject(context)
                }
            }
        }
    }
}

struct MyLists_Previews: PreviewProvider {
    static var previews: some View {
        MyLists()
            .environmentObject(AppContext())
            .background(Color.gray)
    }
}
