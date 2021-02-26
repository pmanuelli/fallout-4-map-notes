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
        
        let y = mainView.mapScrollView.contentOffset.y
        mainView.mapScrollView.setContentOffset(CGPoint(x: 250, y: y), animated: false)
    }
    
    private func setupScrollView() {
        mainView.mapScrollView.delegate = self
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
            
            droppedPin.animateDisappear {
                
                droppedPin.removeFromSuperview()

                self.addLocationView(viewModel: viewModel, at: droppedPinLocation, animated: true)
                
                // TODO: Trigger this behavior using the view model
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
        
        applyCurrentZoomScale(to: view)
        
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
        guard let droppedPinView = currentDroppedPinView else { return }
        
        currentDroppedPinView = nil
        
        droppedPinView.animateDisappear {
            
            droppedPinView.removeFromSuperview()
            
            // TODO: Trigger this behavior using the view model
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
        droppedPinView.applyZoomScale(mainView.mapZoomScale)
        droppedPinView.animateAppear {
            self.viewModel.newLocationPinDropped(coordinates: coordinates)
        }
        
        currentDroppedPinView = droppedPinView
        currentDroppedPinLocation = location
    }
    
    private func convertToCoordinates(location: CGPoint, in view: UIView) -> Coordinates {
        Coordinates(x: Double(location.x / view.bounds.width),
                    y: Double(location.y / view.bounds.height))
    }
    
    @objc
    private func createLocationButtonTouched() {
        enableAddLocationGesture()
        
        // TODO: Trigger this behavior using the view model
        mainView.hideCreateLocationButton()
        mainView.showAndHideCreateLocationMessageAnimated()
    }
    
    private func applyCurrentZoomScale(to view: UIView) {
        view.transform = .scale(1/mainView.mapScrollView.zoomScale)
    }
}

extension MapViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        mainView.mapImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        for locationView in locationViews {
            applyCurrentZoomScale(to: locationView)
        }
    }
}

extension MapViewController: MapLocationViewDelegate {
    
    func mapLocationViewSelected(_ view: MapLocationView, viewModel: MapLocationViewModel) {
        currentSelectedLocationView = view
        self.viewModel.locationViewModelSelected(viewModel)
    }
}
