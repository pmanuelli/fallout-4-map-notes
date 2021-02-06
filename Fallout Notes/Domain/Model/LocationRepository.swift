protocol LocationRepository {
    
    func add(_ location: Location)
    func read(_ locationId: LocationId) -> Location?
    func update(_ location: Location)
}
