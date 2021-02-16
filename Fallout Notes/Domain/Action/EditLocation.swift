struct EditLocationData {
    let location: Location
    let coordinates: Coordinates
    let type: LocationType
    let name: String
    let notes: String
    let features: [Location.Feature]
}

protocol EditLocation {
    func execute(data: EditLocationData)
}

struct EditLocationDefault: EditLocation {
    
    private let repository: LocationRepository
    private let eventBus: EventBusProducer
    
    init(repository: LocationRepository, eventBus: EventBusProducer) {
        self.repository = repository
        self.eventBus = eventBus
    }
    
    func execute(data: EditLocationData) {
        
        let location = Location(id: data.location.id,
                                coordinates: data.coordinates,
                                type: data.type,
                                name: data.name,
                                notes: data.notes,
                                features: data.features)
        
        repository.update(location)
        eventBus.send(event: LocationEditedEvent(location: location))
    }
}

struct LocationEditedEvent: Event {
    let location: Location
}
