import RxSwift

class RxEventBus: EventBus {

    private let eventBusSubject = PublishSubject<Event>()
    
    func send(event: Event) {
        eventBusSubject.onNext(event)
    }
    
    func observe<T>() -> Observable<T> where T : Event {
        eventBusSubject.compactMap { $0 as? T }
    }
}
