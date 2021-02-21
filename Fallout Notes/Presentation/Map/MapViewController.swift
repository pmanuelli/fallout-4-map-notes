import UIKit
import iOSExtensions
import RxSwift

class MapViewController: UIViewController {

    lazy var mainView = MapView.loadNib()
    private let viewModel: MapViewModel
    
    private var locationViews = [MapLocationView]()
    
    private lazy var mapTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapDidReceiveTap(_:)))
    
    private var currentDroppedPinLocation: CGPoint?
    private var currentDroppedPinView: MapDroppedPinView?
    private var currentSelectedLocationView: MapLocationView?
    
    private let locationImageWidth = CGFloat(50)
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupCreateLocationButton()
        
        bindViewModel()
        
        disableAddLocationGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let y = mainView.scrollView.contentOffset.y
        mainView.scrollView.setContentOffset(CGPoint(x: 250, y: y), animated: false)
    }
    
    private func setupScrollView() {
        mainView.scrollView.delegate = self
    }
    
    private func enableAddLocationGesture() {
        mainView.mapImageView.addGestureRecognizer(mapTapGestureRecognizer)
    }
    
    private func disableAddLocationGesture() {
        mainView.mapImageView.removeGestureRecognizer(mapTapGestureRecognizer)
    }
    
    private func setupCreateLocationButton() {
        mainView.createLocationButton.addTarget(self, action: #selector(createLocationButtonTouched), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        
        viewModel.output.locationViewModels
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { controller, viewModels in controller.locationViewModelsChanged(viewModels) })
            .disposed(by: disposeBag)
        
        viewModel.output.locationCreationCancel
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { controller, _ in controller.locationCreationCancelled() })
            .disposed(by: disposeBag)
    }
    
    private func locationViewModelsChanged(_ viewModels: [MapLocationViewModel]) {
        
        removeLocationViewsWhoseViewModelsAreNotPresentIn(viewModels)
                
        for viewModel in viewModels {
            
            if let locationView = locationViews.first(where: { $0.viewModel.id == viewModel.id }) {
                locationView.viewModel = viewModel
            }
            else {
                addLocationView(viewModel: viewModel)
            }
        }
    }
    
    private func removeLocationViewsWhoseViewModelsAreNotPresentIn(_ viewModels: [MapLocationViewModel]) {
        
        let viewModelIds = viewModels.map { $0.id }
        let locationViewIndexesToRemove = locationViews.enumerated()
            .filter { (offset, locationView) in !viewModelIds.contains(locationView.viewModel.id) }
            .map { $0.offset }
        
        for index in locationViewIndexesToRemove {
            removeLocationView(at: index)
        }
    }
    
    private func addLocationView(viewModel: MapLocationViewModel) {
        
        if let droppedPin = currentDroppedPinView, let droppedPinLocation = currentDroppedPinLocation {
            
            currentDroppedPinView = nil
            currentDroppedPinLocation = nil
            
            LocationIconDisappearAnimator.animate(droppedPin, origin: .bottom) {
                
                droppedPin.removeFromSuperview()

                self.addLocationView(viewModel: viewModel, at: droppedPinLocation, animated: true)
                
                // TODO: Trigger this behavior with the view model
                self.disableAddLocationGesture()
                self.mainView.showCreateLocationButton()
            }
        }
        else {
            let location = convertToLocation(coordinates: viewModel.location.coordinates, in: mainView.mapImageView)
            addLocationView(viewModel: viewModel, at: location, animated: false)
        }
    }
    
    private func convertToLocation(coordinates: Coordinates, in view: UIView) -> CGPoint {
        CGPoint(x: view.frame.width * CGFloat(coordinates.x), y: view.frame.height * CGFloat(coordinates.y))
    }
    
    private func addLocationView(viewModel: MapLocationViewModel, at location: CGPoint, animated: Bool) {
        
        let view = MapLocationView(viewModel: viewModel, imageWidth: self.locationImageWidth)
        
        view.addAsSubview(on: mainView.mapImageView, centeringIconAt: location)
        view.delegate = self
        
        if animated {
            LocationIconAppearAnimator.animate(view, origin: .center)
        }
        
        locationViews.append(view)
    }
    
    private func removeLocationView(at index: Int) {
        guard let locationView = locationViews.element(at: index) else { return }
        
        locationViews.remove(at: index)

        LocationIconDisappearAnimator.animate(locationView, origin: .center) {
            locationView.removeFromSuperview()
        }
    }
    
    private func locationCreationCancelled() {
        
        LocationIconDisappearAnimator.animate(currentDroppedPinView!, origin: .bottom) {
            
            self.currentDroppedPinView?.removeFromSuperview()
            self.currentDroppedPinView = nil
            
            // TODO: Trigger this behavior with the view model
            self.disableAddLocationGesture()
            self.mainView.showCreateLocationButton()
        }
    }
    
    @objc
    private func mapDidReceiveTap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: mainView.mapImageView)
        let coordinates = convertToCoordinates(location: location, in: mainView.mapImageView)
                
        let droppedPinView = MapDroppedPinView(imageWidth: 50)
        droppedPinView.addAsSubview(on: mainView.mapImageView, above: location)
        
        currentDroppedPinView = droppedPinView
        currentDroppedPinLocation = location

        LocationIconAppearAnimator.animate(droppedPinView, origin: .bottom) {
            self.viewModel.newLocationPinDropped(coordinates: coordinates)
        }
    }
    
    private func convertToCoordinates(location: CGPoint, in view: UIView) -> Coordinates {
        Coordinates(x: Double(location.x / view.bounds.width),
                    y: Double(location.y / view.bounds.height))
    }
    
    @objc
    private func createLocationButtonTouched() {
        enableAddLocationGesture()
        
        // TODO: Trigger this behavior with the view model
        mainView.hideCreateLocationButton()
        mainView.showAndHideCreateLocationMessageAnimated()
    }
}

extension MapViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        mainView.mapImageView
    }
}

extension MapViewController: MapLocationViewDelegate {
    
    func mapLocationViewSelected(_ view: MapLocationView, viewModel: MapLocationViewModel) {
        currentSelectedLocationView = view
        self.viewModel.locationViewModelSelected(viewModel)
    }
}

//struct InGameLocationRepository {
//
//    func findAll() -> [Location] {
//        [Location(type: .vault, name: "Vault 111", coordinates: Coordinates(x: 0.19791666666666669, y: 0.0685221329331398)),
//         Location(type: .sanctuaryHills, name: "Sanctuary Hills", coordinates: Coordinates(x: 0.2428385391831398, y: 0.0828450471162796)),
//         Location(type: .fillingStation, name: "Red Rocket truck stop", coordinates: Coordinates(x: 0.28173827876647317, y: 0.11490885416666667)),
//         Location(type: .farm, name: "Abernathy farm", coordinates: Coordinates(x: 0.250162755449613, y: 0.16503905753294626)),
//         Location(type: .settlementSmall, name: "Ranger cabin", coordinates: Coordinates(x: 0.20817056794961294, y: 0.14550780753294626)),
//         Location(type: .factory, name: "Wicked Shipping Fleet Lockup", coordinates: Coordinates(x: 0.21858723958333334, y: 0.18164062003294626)),
//         Location(type: .junkyard, name: "Robotics disposal ground", coordinates: Coordinates(x: 0.3395182266831398, y: 0.04296875)),
//         Location(type: .satelliteArray, name: "USAF Satellite Station Olivia", coordinates: Coordinates(x: 0.3819986954331398, y: 0.06835937003294627)),
//         Location(type: .quarry, name: "Thicket Excavations", coordinates: Coordinates(x: 0.3688151016831398, y: 0.10856119791666667)),
//         Location(type: .monument, name: "Museum of Freedom", coordinates: Coordinates(x: 0.32438151041666663, y: 0.14876301834980646)),
//         Location(type: .ruins, name: "Concord", coordinates: Coordinates(x: 0.31022135416666663, y: 0.14550780753294626))]
//    }
//}

