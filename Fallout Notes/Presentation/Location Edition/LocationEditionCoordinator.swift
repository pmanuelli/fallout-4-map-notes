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
    
    func start(coordinates: Coordinates, completion: (() -> Void)? = nil) {
                
        let behavior = CreateLocationBehavior(coordinates: coordinates,
                                              createLocation: Infrastructure.shared.createLocation,
                                              cancelLocationCreation: Infrastructure.shared.cancelLocationCreation)
        
        startEditLocation(behavior: behavior, completion: completion)
    }
    
    func start(location: Location, completion: (() -> Void)? = nil) {
        
        let behavior = EditLocationBehavior(location: location,
                                            editLocation: Infrastructure.shared.editLocation,
                                            deleteLocation: Infrastructure.shared.deleteLocation)
        
        startEditLocation(behavior: behavior, completion: completion)
    }
    
    private func startEditLocation(behavior: LocationEditionViewModelBehavior, completion: (() -> Void)?) {
        
        self.completion = completion
        
        let viewModel = LocationEditionViewModel(behavior: behavior)
        let viewController = LocationEditionViewController(viewModel: viewModel)

        observeViewModel(viewModel)
        locationEditionViewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: false)
        inheritedNavigationController.present(navigationController, animated: true)
    }
            
    private func observeViewModel(_ viewModel: LocationEditionViewModel) {
        
        viewModel.textEditor = self
        viewModel.actionConfirmator = self
        
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

extension LocationEditionCoordinator: ActionConfirmator {
    
    func requestConfirmation(message: String, acceptMessage: String, cancelMessage: String, completion: @escaping (Bool) -> Void) {
        
        let acceptAction = AlertViewController.Action(title: acceptMessage) {
            
            self.navigationController.dismiss(animated: true) {
                completion(true)
            }
        }
        
        let cancelAction = AlertViewController.Action(title: cancelMessage) {
            self.navigationController.dismiss(animated: true) {
                completion(false)
            }
        }
        
        let controller = AlertViewController(message: message, actions: [acceptAction, cancelAction])
        
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        
        navigationController.present(controller, animated: true)
    }
}
