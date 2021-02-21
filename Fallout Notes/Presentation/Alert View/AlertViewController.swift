import UIKit

class AlertViewController: UIViewController {

    struct Action {
        let title: String
        let isDestructive: Bool
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
        button.fontSize = 20
        button.setupDefaultStyleForHighlightedState()
        
        if action.isDestructive {
            button.setTitleColor(.red, for: .normal)
        }
        
        button.addTarget(self, action: #selector(actionButtonTouchedUpInside(_:)), for: .touchUpInside)
        
        return button
    }
            
    @objc
    private func actionButtonTouchedUpInside(_ button: UIButton) {
                
        guard let buttonIndex = mainView.buttonsStackView.arrangedSubviews.firstIndex(of: button),
              let action = actions.element(at: buttonIndex) else { return }
        
        action.handler()
    }
}
