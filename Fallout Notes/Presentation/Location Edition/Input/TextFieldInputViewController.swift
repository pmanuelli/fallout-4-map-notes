import UIKit

class TextFieldInputViewController: UIViewController {

    lazy var mainView = TextFieldInputView.loadNib()

    var completion: ((String) -> Void)?
    
    private let text: String
    
    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.textField.delegate = self
        mainView.textField.text = text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.textField.becomeFirstResponder()
    }
}

extension TextFieldInputViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        completion?(text)
        return false
    }
}
