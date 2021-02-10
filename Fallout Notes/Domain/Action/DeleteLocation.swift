protocol DeleteLocation {
    func execute(locationId: Location.Id)
}

struct DeleteLocationDefault: DeleteLocation {
    
    private let repository: LocationRepository
    private let eventBus: EventBusProducer
    
    init(repository: LocationRepository, eventBus: EventBusProducer) {
        self.repository = repository
        self.eventBus = eventBus
    }
    
    func execute(locationId: Location.Id) {
        repository.delete(locationId)
        eventBus.send(event: LocationDeletedEvent(locationId: locationId))
    }
}

struct LocationDeletedEvent: Event {
    let locationId: Location.Id
}

