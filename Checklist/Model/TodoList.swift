//
//  TodoList.swift
//  Checklist
//
//  Created by Bruno Cardoso Ambrosio on 02/02/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

class TodoList {
    
    enum Priority: Int, CaseIterable {
        case high, medium, low, no
    }
    
    private var highPriorityTodos: [ChecklistItem] = []
    private var mediumPriorityTodos: [ChecklistItem] = []
    private var lowPriorityTodos: [ChecklistItem] = []
    private var noPriorityTodos: [ChecklistItem] = []
    private var titles = [
        "Take a jog",
        "Watch a movie",
        "Code an app",
        "Walk the dog",
        "Do the dishes"
    ]
    
    init(mockQuantity: Int = 5) {
        for _ in 0 ... mockQuantity {
            _ = newTodo()
        }
        
    }
    
    func move(item: ChecklistItem, from sourceList: Priority, at sourceIndex: Int, to destinationList: Priority, at destinationIndex: Int){
        remove(item, from: sourceList, at: sourceIndex)
        addTodo(item, for: destinationList, at: destinationIndex)
    }
    
    func remove(_ item: ChecklistItem, from priority: Priority, at index: Int){
        switch priority {
        case .high:
            highPriorityTodos.remove(at: index)
        case .medium:
            mediumPriorityTodos.remove(at: index)
        case .low:
            lowPriorityTodos.remove(at: index)
        case .no:
            noPriorityTodos.remove(at: index)
        }
    }
    
    func header(for priority: Priority) -> String {
        switch priority {
        case .high:
            return "High Priority Todos"
        case .medium:
            return "Medium Priority Todos"
        case .low:
            return "Low Priority Todos"
        case .no:
            return "Someday Todos items"
        }
    }
    
    func todoList(for priority: Priority) -> [ChecklistItem] {
        switch priority {
        case .high:
            return highPriorityTodos
        case .medium:
            return mediumPriorityTodos
        case .low:
            return lowPriorityTodos
        case .no:
            return noPriorityTodos
        }
    }
    
    func addTodo(_ item: ChecklistItem, for priority: Priority, at index: Int = -1) {
        appendOrInsert(item: item, priority: priority, index: index)
    }
    
    private func appendTodo(_ item: ChecklistItem, for priority: Priority) {
        switch priority {
        case .high:
            highPriorityTodos.append(item)
        case .medium:
            mediumPriorityTodos.append(item)
        case .low:
            lowPriorityTodos.append(item)
        case .no:
            noPriorityTodos.append(item)
        }
        
    }
    
    private func insertTodo(_ item: ChecklistItem, for priority: Priority, at index: Int) {
        switch priority {
        case .high:
            highPriorityTodos.append(item)
        case .medium:
            mediumPriorityTodos.append(item)
        case .low:
            lowPriorityTodos.append(item)
        case .no:
            noPriorityTodos.append(item)
        }
        
    }
    
    private func appendOrInsert(item: ChecklistItem, priority: Priority, index: Int) {
        if index < 0 {
            appendTodo(item, for: priority)
        } else {
            insertTodo(item, for: priority, at: index)
        }
    }
    
    private func newTodo() -> ChecklistItem {
        let item = ChecklistItem(genTitle())
        if Int.random(in: 0 ... 10) % 2 == 0 {
            item.checked = false
        }else {
            item.checked = true
        }
        if let priority = Priority(rawValue: Int.random(in: 1 ... Priority.allCases.count))
        {
            addTodo(item, for: priority)
        }
        return item
    }
    
    private func genTitle() -> String {
        let randomNumber = Int.random(in: 0 ... titles.count - 1)
        return titles[randomNumber]
    }
}
