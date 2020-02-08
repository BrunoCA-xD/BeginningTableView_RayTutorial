//
//  ViewController.swift
//  Checklist
//
//  Created by Bruno Cardoso Ambrosio on 02/02/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet var checklistTableView: UITableView!
    
    // MARK: - Actions
    @IBAction func addItem(_ sender: Any) {

        let newRowIndex = todoList.todos.count
        _ = todoList.newTodo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        checklistTableView.insertRows(at: [indexPath], with: .automatic)
        

    }
    // MARK: - Attributes
    var todoList: TodoList
    
    // MARK: - Init's
    required init?(coder: NSCoder) {
        todoList = TodoList()
        
        super.init(coder: coder)
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        checklistTableView.register(ChecklistTableViewCell.self)

        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - UITableViewDatasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChecklistTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let item = todoList.todos[indexPath.row]
        
        configureText(cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChecklistTableViewCell else { return }
        let item = todoList.todos[indexPath.row]
        configureCheckmark(for: cell, with: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoList.todos.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
    
    
    // MARK: - Helpers
    private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        item.toggleChecked()
    }
    
    private func configureText(_ cell: UITableViewCell, with item: ChecklistItem) {
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = item.text
        }
    }
    
}


