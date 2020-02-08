//
//  TodoList.swift
//  Checklist
//
//  Created by Bruno Cardoso Ambrosio on 02/02/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

class TodoList {
    var todos: [ChecklistItem] = []
    
    var titles = [
        "Take a jog",
        "Watch a movie",
        "Code an app",
        "Walk the dog",
        "Do the dishes"
    ]
    
    init() {
        for _ in 0 ... 5 {
          _ = newTodo()
        }
        
    }
    
    func newTodo() -> ChecklistItem {
        let item = ChecklistItem(genTitle())
        if Int.random(in: 0 ... 10) % 2 == 0 {
            item.checked = false
        }else {
            item.checked = true
        }
        
        todos.append(item)
        return item
    }
    
    private func genTitle() -> String {
        let randomNumber = Int.random(in: 0 ... titles.count - 1)
        return titles[randomNumber]
    }
}
