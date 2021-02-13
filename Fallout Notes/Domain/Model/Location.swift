struct Location {
    
    typealias Id = String

    let id: Id
    let coordinates: Coordinates
    let type: LocationType
    let name: String
    let notes: String
    let features: [Feature]
}

struct Coordinates {
    let x: Double
    let y: Double
}

enum Feature {
    
    case armorWorkbench
    case weaponWorkbench
    case powerArmorStation
}
