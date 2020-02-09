//
//  ViewController.swift
//  Checklist
//
//  Created by Bruno Cardoso Ambrosio on 02/02/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    // MARK: - Attributes
    var todoList: TodoList
    
    // MARK: - Outlets
    @IBOutlet var checklistTableView: UITableView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checklistTableView.reloadData()
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
        checklistTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoList.todos.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            checklistTableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        performSegue(withIdentifier: "editItemSegue", sender: indexPath)
        
    }
    
    
    // MARK: - Helpers
    private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        guard let checkmark = cell.viewWithTag(1001) as? UILabel else { return }
        if item.checked {
            checkmark.text = "√"
        } else {
            checkmark.text = " "
        }
        item.toggleChecked()
    }
    
    private func configureText(_ cell: UITableViewCell, with item: ChecklistItem) {
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = item.text
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItemSegue",
            let vc = segue.destination as? ItemDetailsTableViewController{
            vc.delegate = self
            vc.todoList = todoList
        } else if segue.identifier == "editItemSegue",
            let vc = segue.destination as? ItemDetailsTableViewController,
            let indexPath = sender as? IndexPath{
            vc.delegate = self
            vc.itemToEdit = todoList.todos[indexPath.row]
        }
    }
}
// MARK: - AddItemViewControllerDelegate
extension ChecklistViewController: ItemDetailsTableViewControllerDelegate {
   
    func itemDetailsTableViewController(_ controller: ItemDetailsTableViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        todoList.todos.append(item)
    }
    
    func itemDetailsTableViewController(_ controller: ItemDetailsTableViewController, didFinishEditing item: ChecklistItem) {
        if let index = todoList.todos.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = checklistTableView.cellForRow(at: indexPath) else { return }
            configureText(cell, with: item)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    func itemDetailsTableViewControllerDidCancel(_ controller: ItemDetailsTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
}
