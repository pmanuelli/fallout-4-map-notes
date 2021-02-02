import Foundation

class Infrastructure {
    
    static let shared = Infrastructure()
    
    private init() { }
    
    lazy var eventBus: EventBus = RxEventBus()
    lazy var locationIdGenerator: LocationIdGenerator = UUIDLocationIdGenerator()
    lazy var locationRepository: LocationRepository = InMemoryLocationRepository()
    
    lazy var createLocation = CreateLocationDefault(repository: locationRepository,
                                                    idGenerator: locationIdGenerator,
                                                    eventBus: eventBus)
}