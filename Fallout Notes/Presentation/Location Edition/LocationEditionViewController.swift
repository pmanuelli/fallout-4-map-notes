import UIKit
import RxSwift
import RxCocoa

class LocationEditionViewController: UIViewController {
    
    lazy var mainView = LocationEditionView.loadNib()
    private let viewModel: LocationEditionViewModel
    
    private var cellDequeues: [[LocationEditionTableViewCellDequeue]] = [[.init(identifier: IconTableViewCell.identifier),
                                                                          .init(identifier: NameTableViewCell.identifier),
                                                                          .init(identifier: NotesTableViewCell.identifier)],
                                                                         [.init(identifier: ArmorWorkbenchTableViewCell.identifier)],
                                                                         [.init(identifier: DeleteLocationTableViewCell.identifier)]]
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        cellDequeues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDequeues[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellDequeues[indexPath.section][indexPath.row].tableView(tableView, cellForRowAt: indexPath, viewModel: viewModel)
    }
}
