//
//  Todo.swift
//  ToDoApp
//
//  Created by hong on 2023/08/01.
//

import Foundation

public final class Todo: Codable {
    var title: String
    var context: String
    var image: Data?
    var targetTime: Date
    var isCompleted: Bool
    
    init(title: String, context: String, image: Data? = nil, targetTime: Date, isCompleted: Bool = false) {
        self.title = title
        self.context = context
        self.image = image
        self.targetTime = targetTime
        self.isCompleted = isCompleted
    }
}

public extension Todo{
    static var mock = Todo(title: "테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트", context: "테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트", targetTime: Date())
}
