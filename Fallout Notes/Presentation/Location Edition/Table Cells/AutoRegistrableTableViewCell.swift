import UIKit

protocol AutoRegistrableTableViewCell: UITableViewCell {
    
    static var identifier: String { get }
    static var nib: UINib { get }
    
    static func register(on tableView: UITableView)
}

extension AutoRegistrableTableViewCell {
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: Bundle(for: self)) }
    
    static func register(on tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
}
