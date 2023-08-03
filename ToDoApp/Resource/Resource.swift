//
//  Resource.swift
//  Resource
//
//  Created by hong on 2023/08/01.
//

import UIKit

public class Resource {
    public enum Storyboard {}
    public enum Asset {}
}

public extension Resource.Storyboard {
    static var MainViewStoryBoard: UIStoryboard {
           UIStoryboard(name: "TodoViewController", bundle: Bundle(for: Resource.self))
    }
    static var ToDoDetailViewStoryBoard: UIStoryboard {
        UIStoryboard(name: "TodoListViewController", bundle: Bundle(for: Resource.self))
    }
    static var TodoCompleteViewController: UIStoryboard {
        UIStoryboard(name: "TodoCompleteViewController", bundle: Bundle(for: Resource.self))
    }
    static var TodoAddViewController: UIStoryboard {
        UIStoryboard(name: "TodoAddViewController", bundle: Bundle(for: Resource.self))
    }
}
