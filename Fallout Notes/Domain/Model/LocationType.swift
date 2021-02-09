enum LocationType: String {
    case building
    case dome
    case factory
    case farm
    case fillingStation
    case junkyard
    case military
    case monument
    case pondLake
    case quarry
    case railRoad
    case ruins
    case sanctuaryHills
    case satelliteArray
    case settlementSmall
    case vault
    case water
}

extension LocationType: CaseIterable { }
