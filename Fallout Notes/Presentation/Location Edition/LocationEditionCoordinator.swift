import UIKit
import RxSwift
import RxCocoa

class LocationEditionCoordinator {
    
    private let inheritedNavigationController: UINavigationController
    
    private let navigationController = UINavigationController()
    private var locationEditionViewModel: LocationEditionViewModel?
    private var completion: (() -> Void)?
        
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.inheritedNavigationController = navigationController
        self.navigationController.modalPresentationStyle = .overFullScreen
    }
        
    func start(location: Location, completion: (() -> Void)? = nil) {
        
        self.completion = completion
        
        let viewModel = LocationEditionViewModel(location: location,
                                                 editLocation: Infrastructure.shared.editLocation,
                                                 deleteLocation: Infrastructure.shared.deleteLocation)
        
        let viewController = LocationEditionViewController(viewModel: viewModel)

        observeViewModel(viewModel)
        locationEditionViewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: false)
        inheritedNavigationController.present(navigationController, animated: true)
    }
            
    private func observeViewModel(_ viewModel: LocationEditionViewModel) {
        
        viewModel.textEditor = self
        
        viewModel.output.doneButtonTouch
            .withUnretained(self)
            .subscribe(onNext: { coordinator, data in coordinator.stop() })
            .disposed(by: disposeBag)
        
        viewModel.output.cancelButtonTouch
            .withUnretained(self)
            .subscribe(onNext: { coordinator, _ in coordinator.stop() })
            .disposed(by: disposeBag)
        
        viewModel.output.changeLocationTypeButtonTouch
            .withUnretained(self)
            .subscribe(onNext: { coordinator, _ in coordinator.startLocationIconSelection() })
            .disposed(by: disposeBag)
    }
    
    private func stop() {
        inheritedNavigationController.dismiss(animated: true)
        completion?()
    }
        
    private func startLocationIconSelection() {
        
        let viewModel = LocationIconSelectionViewModel()
        let viewController = LocationIconSelectionViewController(viewModel: viewModel)
        
        observeViewModel(viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func observeViewModel(_ viewModel: LocationIconSelectionViewModel) {
        
        viewModel.output.userDidSelectLocationType
            .subscribe(onSuccess: { [weak self] in self?.onUserDidSelectLocationType($0) })
            .disposed(by: disposeBag)
    }
    
    private func onUserDidSelectLocationType(_ type: LocationType) {

        navigationController.popViewController(animated: true)
        
        perform(after: 0.5) {
            self.locationEditionViewModel?.changeLocationType(type)
        }
    }
}

extension LocationEditionCoordinator: TextEditor {
    
    func editShortText(_ text: String, completion: @escaping (String) -> Void) {
                
        let controller = TextFieldInputViewController(text: text)
        controller.completion = { [weak self] in self?.onTextEditorViewControllerCompleted(text: $0, editCompletion: completion) }
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func editLongText(_ text: String, completion: @escaping (String) -> Void) {
                
        let controller = TextViewInputViewController(text: text)
        controller.completion = { [weak self] in self?.onTextEditorViewControllerCompleted(text: $0, editCompletion: completion) }
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func onTextEditorViewControllerCompleted(text: String, editCompletion: @escaping (String) -> Void) {
        
        editCompletion(text)
        navigationController.popViewController(animated: true)
    }
}
