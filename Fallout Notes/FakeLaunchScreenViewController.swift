import UIKit

class FakeLaunchScreenViewController: UIViewController {

    lazy var mainView = FakeLaunchScreenView.loadNib()
    private let duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let images = (1...8).compactMap { UIImage(named: "launch_screen_\($0)") }
        mainView.vaultBoyImageView.animationImages = images
        mainView.vaultBoyImageView.animationDuration = duration
        mainView.vaultBoyImageView.animationRepeatCount = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.vaultBoyImageView.startAnimating()
    }
}
