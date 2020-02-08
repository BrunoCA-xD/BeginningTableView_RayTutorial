//
//  Identifiable.swift
//  Checklist
//
//  Created by Bruno Cardoso Ambrosio on 02/02/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

protocol Identifiable: class {
    static var reusableIdentifier: String {get}
}

extension Identifiable where Self: UIView {
    static var reusableIdentifier: String {
        return NSStringFromClass(self)
    }
}

// All UITableViewCell's are now Identifiable and have a reusableIdentifier to be registred
extension UITableViewCell: Identifiable { }
