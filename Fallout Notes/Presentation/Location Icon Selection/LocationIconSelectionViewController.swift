import UIKit
import RxSwift
import RxCocoa

class LocationIconSelectionViewController: UIViewController {

    private lazy var mainView = LocationIconSelectionView.loadNib()
    private let viewModel: LocationIconSelectionViewModel
    
    @IBOutlet private var locationIconsTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: LocationIconSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.locationIconsTableView.register(LocationIconTableViewCell.nib,
                                                 forCellReuseIdentifier: LocationIconTableViewCell.reuseIdentifier)
        
        viewModel.output.cellViewModels
            .bind(to: mainView.locationIconsTableView.rx.items) { tableView, index, viewModel in
                self.dequeueCell(tableView: tableView, index: index, viewModel: viewModel)
        }
        .disposed(by: disposeBag)
    }
    
    private func dequeueCell(tableView: UITableView, index: Int, viewModel: LocationIconTableViewCellViewModel) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationIconTableViewCell.reuseIdentifier,
                                                 for: IndexPath(row: index, section: 0))
        
        (cell as? LocationIconTableViewCell).let { $0.setViewModel(viewModel) }
        
        return cell
    }
}

extension Optional {
    
    func `let`(_ block: (Wrapped) -> Void) {
        if let wrapped = self { block(wrapped) }
    }
}
