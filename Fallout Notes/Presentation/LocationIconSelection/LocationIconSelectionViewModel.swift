import RxSwift
import RxCocoa

class LocationIconSelectionViewModel {
    
    struct Output {
        let userDidSelectLocationType: Single<LocationType>
        let cellViewModels: Observable<[LocationIconTableViewCellViewModel]>
    }
    
    lazy var output = Output(userDidSelectLocationType: userDidSelectLocationTypeSubject.asSingle(),
                             cellViewModels: cellViewModelsSubject.asObservable())
    
    private let userDidSelectLocationTypeSubject = PublishSubject<LocationType>()    
    private let cellViewModelsSubject = ReplaySubject<[LocationIconTableViewCellViewModel]>.create(bufferSize: 1)
    
    init() {
        
        let viewModels = [LocationIconTableViewCellViewModel(type: .vault, name: "Vault"),
                          LocationIconTableViewCellViewModel(type: .building, name: "Building"),
                          LocationIconTableViewCellViewModel(type: .ruins, name: "Ruins"),
                          LocationIconTableViewCellViewModel(type: .pondLake, name: "Pond lake"),
                          LocationIconTableViewCellViewModel(type: .farm, name: "Farm")]
        
        viewModels.forEach { $0.delegate = self }
        
        cellViewModelsSubject.onNext(viewModels)
    }
}

extension LocationIconSelectionViewModel: LocationIconTableViewCellViewModelDelegate {
    
    func cellViewModelSelected(_ viewModel: LocationIconTableViewCellViewModel) {
        userDidSelectLocationTypeSubject.onNext(viewModel.type)
        userDidSelectLocationTypeSubject.onCompleted()
    }
}
