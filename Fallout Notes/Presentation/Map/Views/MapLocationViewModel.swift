struct MapLocationViewModel {

    typealias Id = String
    
    let location: Location

    let id: Id
    let type: LocationType
    let name: String
        
    init(location: Location) {
        self.location = location
        self.id = location.id
        self.type = location.type
        self.name = location.name
    }
}
