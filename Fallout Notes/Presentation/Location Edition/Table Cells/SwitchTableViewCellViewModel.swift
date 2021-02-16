struct SwitchTableViewCellViewModel {
    
    let title: String
    let initialValue: Bool
    private let onValueChanged: (Bool) -> Void
        
    init(title: String, initialValue: Bool, onValueChanged: @escaping (Bool) -> Void) {
        self.title = title
        self.initialValue = initialValue
        self.onValueChanged = onValueChanged
    }
    
    func cellValueChanged(enabled: Bool) {
        onValueChanged(enabled)
    }
}
