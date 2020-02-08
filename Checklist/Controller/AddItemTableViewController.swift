//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Bruno Cardoso Ambrosio on 08/02/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    // MARK: - Actions
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        print("\(titleTextField.text)")
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - View lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        navigationItem.largeTitleDisplayMode = .never
        addBarButton.isEnabled = false
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
extension AddItemTableViewController: UITextFieldDelegate {
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
