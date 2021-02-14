import UIKit

class LocationEditionView: UIView {

    @IBOutlet var tableView: UITableView!
    
    override func awakeFromNib() {
        
        IconAndNameTableViewCell.register(on: tableView)
        NotesTableViewCell.register(on: tableView)
        DeleteLocationTableViewCell.register(on: tableView)
        ArmorWorkbenchTableViewCell.register(on: tableView)
    }
}
