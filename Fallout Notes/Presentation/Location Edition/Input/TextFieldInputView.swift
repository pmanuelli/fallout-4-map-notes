import UIKit

class TextFieldInputView: UIView {

    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GreenBlurEffect.apply(to: textField)
    }
}
