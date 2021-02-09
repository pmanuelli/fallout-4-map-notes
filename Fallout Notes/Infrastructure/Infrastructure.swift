import Foundation

class Infrastructure {
    
    static let shared = Infrastructure()
    
    private init() { }
    
    lazy var eventBus: EventBus = RxEventBus()
    lazy var locationIdGenerator: LocationIdGenerator = UUIDLocationIdGenerator()
//    lazy var locationRepository: LocationRepository = InMemoryLocationRepository()
    lazy var locationRepository: LocationRepository = UserDefaultsLocationRepository()

    
    lazy var createLocation: CreateLocation = CreateLocationDefault(repository: locationRepository,
                                                                    idGenerator: locationIdGenerator,
                                                                    eventBus: eventBus)
    
    lazy var cancelLocationCreation: CancelLocationCreation = CancelLocationCreationDefault(eventBus: eventBus)
    
    lazy var editLocation: EditLocation = EditLocationDefault(repository: locationRepository, eventBus: eventBus)
}
