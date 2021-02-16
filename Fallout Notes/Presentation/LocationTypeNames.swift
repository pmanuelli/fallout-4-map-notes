struct LocationTypeNames {

    static func name(for locationType: LocationType) -> String {
        switch locationType {
        case .bed:
            return "Bed"
        case .building:
            return "Building"
        case .dome:
            return "Dome"
        case .factory:
            return "Factory"
        case .farm:
            return "Farm"
        case .fillingStation:
            return "Filling Station"
        case .junkyard:
            return "Junk Yard"
        case .lowRise:
            return "Low Rise"
        case .military:
            return "Military"
        case .monument:
            return "Monument"
        case .pondLake:
            return "Pond Lake"
        case .quarry:
            return "Quarry"
        case .railRoad:
            return "Rail Road"
        case .ruins:
            return "Ruins"
        case .sanctuaryHills:
            return "Sanctuary Hills"
        case .satelliteArray:
            return "Satellite Array"
        case .settlementSmall:
            return "Small Settlement"
        case .vault:
            return "Vault"
        case .water:
            return "Water"
        }
    }
}
