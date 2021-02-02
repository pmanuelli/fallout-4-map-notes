import Foundation

protocol CancelLocationCreation {
    func execute()
}

struct CancelLocationCreationDefault: CancelLocationCreation {
    
    private let eventBus: EventBusProducer
    
    init(eventBus: EventBusProducer) {
        self.eventBus = eventBus
    }
    
    func execute() {
        eventBus.send(event: LocationCreationCancelledEvent())
    }
}

struct LocationCreationCancelledEvent: Event { }
