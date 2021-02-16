import UIKit
import RxSwift
import RxCocoa

class LocationEditionViewController: UIViewController {
    
    lazy var mainView = LocationEditionView.loadNib()
    private let viewModel: LocationEditionViewModel
    
    private lazy var cellDequeues = createCellDequeues()
    
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
    
    private func createCellDequeues() -> [[LocationEditionTableViewCellDequeue]] {
        
        let armorWorkbenchViewModel = SwitchTableViewCellViewModel(title: "Armor Workbench",
                                                                   initialValue: viewModel.hasArmorWorkbench,
                                                                   onValueChanged: viewModel.armorWorkbenchToggleChanged(enabled:))

        let weaponWorkbenchViewModel = SwitchTableViewCellViewModel(title: "Weapon Workbench", initialValue: viewModel.hasWeaponWorkbench,
                                                                    onValueChanged: viewModel.weaponWorkbenchToggleChanged(enabled:))

        return [[.init(identifier: IconTableViewCell.identifier, locationEditionViewModel: viewModel),
                 .init(identifier: NameTableViewCell.identifier, locationEditionViewModel: viewModel),
                 .init(identifier: NotesTableViewCell.identifier, locationEditionViewModel: viewModel)],
                [.init(identifier: SwitchTableViewCell.identifier, switchTableCellViewModel: armorWorkbenchViewModel),
                 .init(identifier: SwitchTableViewCell.identifier, switchTableCellViewModel: weaponWorkbenchViewModel)],
                [.init(identifier: DeleteLocationTableViewCell.identifier, locationEditionViewModel: viewModel)]]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        cellDequeues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDequeues[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellDequeues[indexPath.section][indexPath.row].tableView(tableView, cellForRowAt: indexPath)
    }
}
