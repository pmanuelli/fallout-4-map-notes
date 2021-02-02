import RxSwift

class LocationIconTableViewCellViewModel {

    weak var delegate: LocationIconTableViewCellViewModelDelegate?
    
    let type: LocationType
    let name: String
    
    init(type: LocationType, name: String, delegate: LocationIconTableViewCellViewModelDelegate? = nil) {
        self.type = type
        self.name = name
        self.delegate = delegate
    }
    
    func cellSelected() {
        delegate?.cellViewModelSelected(self)
    }
}

protocol LocationIconTableViewCellViewModelDelegate: AnyObject {
    
    func cellViewModelSelected(_ viewModel: LocationIconTableViewCellViewModel)
}
