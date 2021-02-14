import UIKit
import RxSwift
import RxCocoa

class LocationEditionViewController: UIViewController {
    
    lazy var mainView = LocationEditionView.loadNib()
    private let viewModel: LocationEditionViewModel
    
    private var cellDequeues = [LocationEditionTableViewCellDequeue(identifier: IconAndNameTableViewCell.identifier),
                                LocationEditionTableViewCellDequeue(identifier: NotesTableViewCell.identifier),
                                LocationEditionTableViewCellDequeue(identifier: DeleteLocationTableViewCell.identifier)]
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: LocationEditionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.dataSource = self
                
        setupNavigationItemButtons()
    }
    
    private func setupNavigationItemButtons() {
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: viewModel,
                                           action: #selector(LocationEditionViewModel.cancelButtonTouched))
                        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: viewModel,
                                         action: #selector(LocationEditionViewModel.doneButtonTouched))
                
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        
        viewModel.output.doneButtonEnabled
            .subscribe(doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

extension LocationEditionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDequeues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellDequeues[indexPath.row].tableView(tableView, cellForRowAt: indexPath, viewModel: viewModel)
    }
}
