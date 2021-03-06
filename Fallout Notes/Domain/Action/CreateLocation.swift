struct CreateLocationData {
    let coordinates: Coordinates
    let type: LocationType
    let name: String
    let notes: String
    let features: [Location.Feature]
}

protocol CreateLocation {
    func execute(data: CreateLocationData)
}

struct CreateLocationDefault: CreateLocation {
    
    private let repository: LocationRepository
    private let idGenerator: LocationIdGenerator
    private let eventBus: EventBusProducer
    
    init(repository: LocationRepository, idGenerator: LocationIdGenerator, eventBus: EventBusProducer) {
        self.repository = repository
        self.idGenerator = idGenerator
        self.eventBus = eventBus
    }
    
    func execute(data: CreateLocationData) {
    
        let location = Location(id: idGenerator.generate(),
                                coordinates: data.coordinates,
                                type: data.type,
                                name: data.name,
                                notes: data.notes,
                                features: data.features)
        
        repository.create(location)
        eventBus.send(event: LocationCreatedEvent(location: location))
    }
}

struct LocationCreatedEvent: Event {
    let location: Location
}
