import UIKit

class TextViewInputView: UIView {

    @IBOutlet var textView: UITextView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GreenBlurEffect.apply(to: textView)        
    }
}
