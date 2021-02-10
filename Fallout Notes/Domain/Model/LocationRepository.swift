protocol LocationRepository {
    
    func create(_ location: Location)
    func readAll() -> [Location]
    func update(_ location: Location)
    func delete(_ locationId: Location.Id)
}
