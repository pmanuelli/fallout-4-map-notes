import UIKit

class AlertViewController: UIViewController {

    struct Action {
        let title: String
        let handler: () -> Void
    }
    
    private lazy var mainView = AlertView.loadNib()
    
    private let message: String
    private let actions: [Action]
    
    init(message: String, actions: [Action]) {
        self.message = message
        self.actions = actions
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.messageLabel.text = message
        addActionButtons()
    }
    
    private func addActionButtons() {
        
        for action in actions {
            addButtonForAction(action)
        }
    }
    
    private func addButtonForAction(_ action: Action) {
        mainView.buttonsStackView.addArrangedSubview(createButtonForAction(action))
    }
    
    private func createButtonForAction(_ action: Action) -> UIButton {
        
        let button = HUDButton(type: .custom)
        button.setTitle(action.title, for: .normal)
        
        button.addTarget(self, action: #selector(actionButtonTouchedUpInside(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(setButtonAsTouched(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(setButtonAsNotTouched(_:)), for: .touchDragOutside)
        button.addTarget(self, action: #selector(setButtonAsTouched(_:)), for: .touchDragInside)
        
        return button
    }
    
    @objc
    private func setButtonAsTouched(_ button: UIButton) {
        button.backgroundColor = Colors.greenDark
        button.setTitleColor(.black, for: .normal)
        button.setTitleShadowColor(.clear, for: .normal)
        button.titleLabel?.layerShadowRadius = 0
        button.titleLabel?.layerShadowOpacity = 0
    }
    
    @objc
    private func setButtonAsNotTouched(_ button: UIButton) {
        
        button.setTitleColor(Colors.greenDark, for: .normal)
        button.setTitleShadowColor(.black, for: .normal)
        button.backgroundColor = .clear
        
        button.titleLabel?.textColor = Colors.greenDark
        button.titleLabel?.layerShadowOffset = CGSize(width: 1, height: 1)
        button.titleLabel?.layerShadowRadius = 0
        button.titleLabel?.layerShadowOpacity = 1
    }
        
    @objc
    private func actionButtonTouchedUpInside(_ button: UIButton) {
                
        guard let buttonIndex = mainView.buttonsStackView.arrangedSubviews.firstIndex(of: button),
              let action = actions.element(at: buttonIndex) else { return }
        
        action.handler()
    }
}
