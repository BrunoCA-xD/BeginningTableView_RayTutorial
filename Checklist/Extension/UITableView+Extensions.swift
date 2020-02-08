//
//  UITableView+Extensions.swift
//  Checklist
//
//  Created by Bruno Cardoso Ambrosio on 02/02/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

extension UITableView {
    
    // registers the cell whitout a .xib passing only the 'cell.self'
    func register<T: UITableViewCell>(_ : T.Type) {
        register(T.self, forCellReuseIdentifier: T.reusableIdentifier)
    }
    // registers the cell with a .xib passing only 'cell.self'
    func register<T: UITableViewCell>(_ : T.Type) where T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)

        register(nib, forCellReuseIdentifier: T.reusableIdentifier)
    }
    
    // Dequeues the cell with a wanted type (let cell: WantedType = dequeue...) with only the indexPath
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier  \(T.reusableIdentifier)")
        }
        
        return cell
    }
}
