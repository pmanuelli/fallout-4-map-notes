struct MapLocationViewModel {
        
    let location: Location

    let type: LocationType
    let name: String
        
    init(location: Location) {
        self.location = location
        self.type = location.type
        self.name = location.name
    }
}
