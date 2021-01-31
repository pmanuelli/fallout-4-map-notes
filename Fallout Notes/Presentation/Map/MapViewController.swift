import UIKit
import iOSExtensions
import RxSwift

class MapViewController: UIViewController {

    lazy var mainView = MapView.loadNib()
    private let viewModel: MapViewModel
    
    private var currentDroppedPinLocation: CGPoint?
    private var currentDroppedPinView: MapDroppedPinView?
    private var currentLocationIconSelectionViewModel: LocationIconSelectionViewModel?
    
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
        setupAddLocationGesture()
        
        bindViewModel()
    }
    
    private func setupScrollView() {
        mainView.scrollView.delegate = self
    }
    
    private func setupAddLocationGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapDidReceiveTap(_:)))
        mainView.mapImageView.addGestureRecognizer(tapGesture)
    }
    
    private func bindViewModel() {
        
        viewModel.output.newLocationAccept
            .withUnretained(self)
            .subscribe(onNext: { controller, location in controller.acceptNewLocation(type: location.0, name: location.1) })
            .disposed(by: disposeBag)
        
        viewModel.output.newLocationCancel
            .withUnretained(self)
            .subscribe(onNext: { controller, _ in controller.cancelNewLocation() })
            .disposed(by: disposeBag)
    }

    private func acceptNewLocation(type: LocationType, name: String) {
        
        LocationIconDisappearAnimator.animate(currentDroppedPinView!, origin: .bottom) {
            
            self.currentDroppedPinView?.removeFromSuperview()
            self.currentDroppedPinView = nil
            
            let view = MapLocationView(image: Icons.icon(for: type), imageWidth: self.locationImageWidth, name: name)
            
            self.addLocationViewAnimated(view, at: self.currentDroppedPinLocation!)
        }
    }
    
    private func addLocationViewAnimated(_ mapLocationView: MapLocationView, at location: CGPoint, completion: (() -> Void)? = nil) {
        addLocationView(mapLocationView, at: location)
        
        LocationIconAppearAnimator.animate(mapLocationView, origin: .center, completion: completion)
    }
    
    private func addLocationView(_ mapLocationView: MapLocationView, at location: CGPoint) {
        mapLocationView.addAsSubview(on: mainView.mapImageView, centeringIconAt: location)
    }
    
    private func cancelNewLocation() {
        
        LocationIconDisappearAnimator.animate(currentDroppedPinView!, origin: .bottom) {
            
            self.currentDroppedPinView?.removeFromSuperview()
            self.currentDroppedPinView = nil
        }
    }
    
    @objc
    private func mapDidReceiveTap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: mainView.mapImageView)
                
        let droppedPinView = MapDroppedPinView(imageWidth: 50)
        droppedPinView.addAsSubview(on: mainView.mapImageView, above: location)
        
        currentDroppedPinView = droppedPinView
        currentDroppedPinLocation = location

        LocationIconAppearAnimator.animate(droppedPinView, origin: .bottom) {
            self.viewModel.newLocationPinDropped()
        }
    }
    
//    func captureNewLocationMapSnapshot() -> UIImage {
//        
//        let bounds = CGRect(x: 500, y: 0, width: 500, height: 500)
//        let renderer = UIGraphicsImageRenderer(bounds: bounds)
//        
//        return renderer.image { context in
//            self.mainView.mapImageView.layer.render(in: context.cgContext)
//        }
//    }
    
    
//    private func loadInitialLocations() {
//
//        for location in InGameLocationRepository().findAll() {
//            let view = MapLocationView(image: Icons.icon(for: location.type), imageWidth: 50, name: location.name)
//            addLocationView(view, at: location.coordinates)
//        }
//    }
}

extension MapViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        mainView.mapImageView
    }
}

struct InGameLocationRepository {
    
    func findAll() -> [Location] {
        [Location(type: .vault, name: "Vault 111", coordinates: Coordinates(x: 0.19791666666666669, y: 0.0685221329331398)),
         Location(type: .sanctuaryHills, name: "Sanctuary Hills", coordinates: Coordinates(x: 0.2428385391831398, y: 0.0828450471162796)),
         Location(type: .fillingStation, name: "Red Rocket truck stop", coordinates: Coordinates(x: 0.28173827876647317, y: 0.11490885416666667)),
         Location(type: .farm, name: "Abernathy farm", coordinates: Coordinates(x: 0.250162755449613, y: 0.16503905753294626)),
         Location(type: .settlementSmall, name: "Ranger cabin", coordinates: Coordinates(x: 0.20817056794961294, y: 0.14550780753294626)),
         Location(type: .factory, name: "Wicked Shipping Fleet Lockup", coordinates: Coordinates(x: 0.21858723958333334, y: 0.18164062003294626)),
         Location(type: .junkyard, name: "Robotics disposal ground", coordinates: Coordinates(x: 0.3395182266831398, y: 0.04296875)),
         Location(type: .satelliteArray, name: "USAF Satellite Station Olivia", coordinates: Coordinates(x: 0.3819986954331398, y: 0.06835937003294627)),
         Location(type: .quarry, name: "Thicket Excavations", coordinates: Coordinates(x: 0.3688151016831398, y: 0.10856119791666667)),
         Location(type: .monument, name: "Museum of Freedom", coordinates: Coordinates(x: 0.32438151041666663, y: 0.14876301834980646)),
         Location(type: .ruins, name: "Concord", coordinates: Coordinates(x: 0.31022135416666663, y: 0.14550780753294626))]
    }
}

