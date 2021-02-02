typealias LocationId = String

struct Location {
    
    let id: LocationId
    let type: LocationType
    let name: String
    let notes: String
    let coordinates: Coordinates
}

struct Coordinates {
    let x: Double
    let y: Double
}
