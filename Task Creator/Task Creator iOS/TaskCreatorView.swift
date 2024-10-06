//
//  TaskCreatorView.swift
//  Task Creator iOS
//
//  Created by Keyvan Yaghoubian on 10/4/24.
//

import SwiftUI
import DataStore
import Task_Creator
import CoreData

struct TaskCreatorView: View {
    @State var title: String = ""
    let taskCreator: TaskCreator

    init(taskCreator: TaskCreator) {
        self.taskCreator = taskCreator
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Task")
                    .font(.largeTitle)
                Spacer()
            }
            
            TextField(text: $title, label: {
                Text("Describe the task")
            })
            .accentColor(.black)
            
            Spacer()
            
            Button(action: {
                Task {
                    try await taskCreator.create(with: TaskCreationParameters(title: "HI"))
                }
            }, label: {
                Text("Create")
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.black)
                    .cornerRadius(.infinity)
                    .foregroundColor(Color.white)
            })
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }
}

//#Preview {
////    TaskCreatorView()
//}
