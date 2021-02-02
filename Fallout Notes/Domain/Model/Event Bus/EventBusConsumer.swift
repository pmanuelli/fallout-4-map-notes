import RxSwift

protocol EventBusConsumer {
    func observe<T>() -> Observable<T> where T: Event
}
