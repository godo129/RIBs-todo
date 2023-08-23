//
//  AppComponent.swift
//  ToDoApp
//
//  Created by hong on 2023/08/10.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

class AppComponent: Component<EmptyDependency>, RootDependency {
    var todoRepository: TodoRepositoryProtocol
    var imageRepository: ImageRepositoryProtocol
    
    init(
        todoRepository: TodoRepositoryProtocol,
        imageRepository: ImageRepositoryProtocol
    ) {
        self.todoRepository = todoRepository
        self.imageRepository = imageRepository
        super.init(dependency: EmptyComponent())
    }
}
