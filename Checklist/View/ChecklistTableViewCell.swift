//
//  ChecklistTableViewCell.swift
//  Checklist
//
//  Created by Bruno Cardoso Ambrosio on 02/02/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {
    @IBOutlet weak var todoText: UILabel!
    
    @IBOutlet weak var todoIsDone: UILabel!
    
    func config(item: ChecklistItem) {
        todoText.text = item.text
        configCheckmark(item: item)
        
    }
    
    private func configCheckmark(item: ChecklistItem) {
        if item.checked {
            todoIsDone.text = "√"
        }else {
            todoIsDone.text = " "
        }
    }
    
    func toggleChecked(item: ChecklistItem){
        item.toggleChecked()
        configCheckmark(item: item)
    }
}

extension ChecklistTableViewCell: NibLoadableView { }
