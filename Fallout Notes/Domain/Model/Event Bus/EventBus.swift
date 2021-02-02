import RxSwift

protocol EventBusProducer {
    func send(event: Event)
}

protocol EventBusConsumer {
    func observe<T>() -> Observable<T> where T: Event
}

protocol EventBus: EventBusConsumer, EventBusProducer { }
