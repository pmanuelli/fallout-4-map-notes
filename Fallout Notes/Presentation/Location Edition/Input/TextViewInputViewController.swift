import UIKit

class TextViewInputViewController: UIViewController {

    private lazy var mainView = TextViewInputView.loadNib()
    private let text: String

    var completion: ((String) -> Void)?    
    
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

        navigationItem.rightBarButtonItem = createDoneButton()

        mainView.textView.text = text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.textView.becomeFirstResponder()
    }
    
    private func createDoneButton() -> UIBarButtonItem {
        UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTouched))
    }
    
    @objc
    private func doneButtonTouched() {
        completion?(mainView.textView.text)
    }
}
