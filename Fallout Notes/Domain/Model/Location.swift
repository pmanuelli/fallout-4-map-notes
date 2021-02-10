struct Location {
    
    typealias Id = String

    let id: Id
    let type: LocationType
    let name: String
    let notes: String
    let coordinates: Coordinates
}

struct Coordinates {
    let x: Double
    let y: Double
}
