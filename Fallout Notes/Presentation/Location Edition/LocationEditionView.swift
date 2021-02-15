import UIKit

class LocationEditionView: UIView {

    @IBOutlet var tableView: UITableView!
    
    override func awakeFromNib() {
        
        IconTableViewCell.register(on: tableView)
        NameTableViewCell.register(on: tableView)
        NotesTableViewCell.register(on: tableView)
        ArmorWorkbenchTableViewCell.register(on: tableView)
        DeleteLocationTableViewCell.register(on: tableView)
    }
}
