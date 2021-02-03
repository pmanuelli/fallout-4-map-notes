import UIKit

class LocationCreationView: UIView {

    @IBOutlet var iconContainer: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var changeIconButton: UIButton!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var notesTextView: UITextView!
    
    override func awakeFromNib() {
        iconImageView.image = Icons.droppedPin
    }
}
