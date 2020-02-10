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
    let trashBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: nil)
    
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
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checklistTableView.reloadData()
    }
    
    // MARK: - UITableViewDatasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section){
            return todoList.todoList(for: priority).count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChecklistTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let item = recoverItem(indexPath: indexPath){
            cell.config(item: item)
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoList.Priority.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return todoList.header(for: TodoList.Priority(rawValue: section) ?? .medium )
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateTrashButtonEnabled()
            return
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? ChecklistTableViewCell else { return }
        if let item = recoverItem(indexPath: indexPath) {
            cell.toggleChecked(item: item)
        }
        checklistTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateTrashButtonEnabled()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to
        destinationIndexPath: IndexPath) {
        if let item = recoverItem(indexPath: sourceIndexPath),
            let srcPriority = priorityForSectionIndex(sourceIndexPath.section),
            let destPriority = priorityForSectionIndex(destinationIndexPath.section) {
            todoList.move(item: item, from: srcPriority , at: sourceIndexPath.row, to: destPriority, at: destinationIndexPath.row)
        }
        checklistTableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,
            let priority = priorityForSectionIndex(indexPath.section),
            let item = recoverItem(indexPath: indexPath){
            todoList.remove(item, from: priority, at: indexPath.row)
            checklistTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        performSegue(withIdentifier: "editItemSegue", sender: indexPath)
        
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
            if let item = recoverItem(indexPath: indexPath){
                vc.itemToEdit = item
            }
        }
    }
    
    // MARK: - Helper
    private func updateTrashButtonEnabled() {
        trashBarButton.isEnabled = tableView.indexPathsForSelectedRows != nil
    }
    
    private func recoverItem(indexPath: IndexPath) -> ChecklistItem? {
        if let priority = priorityForSectionIndex(indexPath.section){
            let list = todoList.todoList(for: priority)
            let rowToSelect = indexPath.row > list.count - 1 ? list.count - 1 : indexPath.row
            let item = list[rowToSelect]
            return item
        }
        return nil
    }
    
    private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
        return TodoList.Priority(rawValue: index)
    }
    
    // MARK: - Configs
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(tableView.isEditing, animated: animated)
        
        if editing {
            navigationItem.rightBarButtonItems?.append(trashBarButton)
            trashBarButton.target = self
            trashBarButton.action = #selector(deleteItems(_:))
            trashBarButton.isEnabled = false
            
        } else {
            if let index = navigationItem.rightBarButtonItems?.firstIndex(of: trashBarButton){
                navigationItem.rightBarButtonItems?.remove(at: index)
            }
        }
    }
    
    // MARK: - objc Func's
    @objc func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath  in selectedRows {
                if let item = recoverItem(indexPath: indexPath),
                    let priority = priorityForSectionIndex(indexPath.section){
                    todoList.remove(item, from: priority, at: indexPath.row)
                    
                }
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
            updateTrashButtonEnabled()
        }
    }
}

// MARK: - AddItemViewControllerDelegate
extension ChecklistViewController: ItemDetailsTableViewControllerDelegate {
    
    func itemDetailsTableViewController(_ controller: ItemDetailsTableViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        todoList.addTodo(item, for: .medium)
    }
    
    func itemDetailsTableViewController(_ controller: ItemDetailsTableViewController, didFinishEditing item: ChecklistItem) {
        
        for priority in TodoList.Priority.allCases {
            let currentList = todoList.todoList(for: priority)
            if let index = currentList.firstIndex(of: item){
                let indexPath = IndexPath(row: index, section: priority.rawValue)
                guard let cell = checklistTableView.cellForRow(at: indexPath) as? ChecklistTableViewCell else { return }
                cell.config(item: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailsTableViewControllerDidCancel(_ controller: ItemDetailsTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
}
