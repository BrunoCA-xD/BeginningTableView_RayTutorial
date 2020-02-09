//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Bruno Cardoso Ambrosio on 08/02/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

protocol ItemDetailsTableViewControllerDelegate: class {
    
    func itemDetailsTableViewControllerDidCancel(_ controller: ItemDetailsTableViewController)
    func itemDetailsTableViewController(_ controller: ItemDetailsTableViewController, didFinishAdding item: ChecklistItem)
    func itemDetailsTableViewController(_ controller: ItemDetailsTableViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailsTableViewController: UITableViewController {
    
    // MARK: - Attributes
    weak var delegate: ItemDetailsTableViewControllerDelegate?
    weak var todoList: TodoList?
    weak var itemToEdit: ChecklistItem?
    
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    // MARK: - Actions
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit,
            let text = titleTextField.text{
            item.text = text
            delegate?.itemDetailsTableViewController(self, didFinishEditing: item)
        } else {
            guard let todoText = titleTextField.text else {return}
            let todo = ChecklistItem(todoText)
            delegate?.itemDetailsTableViewController(self, didFinishAdding: todo)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.itemDetailsTableViewControllerDidCancel(self)
    }
    
    // MARK: - View lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        navigationItem.largeTitleDisplayMode = .never
        
        
        if let item = itemToEdit{
            title = "Edit item"
            titleTextField.text = item.text
        }else {
            title = "Add item"
            addBarButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
// MARK: - UITextFieldDelegate
extension ItemDetailsTableViewController: UITextFieldDelegate {
    // This method dismiss the keyboard when the "Done" keyboard button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
            let stringRange = Range(range, in: oldText) else { return false }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        addBarButton.isEnabled = !newText.isEmpty
        return true
    }
}

