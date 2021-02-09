protocol LocationRepository {
    
    func add(_ location: Location)
    func readAll() -> [Location]
    func update(_ location: Location)
}
