import UIKit

struct Icons {
    
    static var building: UIImage { iconImage(named: "building") }
    static var dome: UIImage { iconImage(named: "dome") }
    static var droppedPin: UIImage { iconImage(named: "dropped_pin" )}
    static var factory: UIImage { iconImage(named: "factory") }
    static var farm: UIImage { iconImage(named: "farm") }
    static var fillingStation: UIImage { iconImage(named: "filling_station") }
    static var junkyard: UIImage { iconImage(named: "junkyard") }
    static var military: UIImage { iconImage(named: "military") }
    static var monument: UIImage { iconImage(named: "monument") }
    static var pondLake: UIImage { iconImage(named: "pond_lake") }
    static var quarry: UIImage { iconImage(named: "quarry") }
    static var railRoad: UIImage { iconImage(named: "rail_road") }
    static var ruins: UIImage { iconImage(named: "ruins") }
    static var sanctuaryHills: UIImage { iconImage(named: "sanctuary_hills") }
    static var satelliteArray: UIImage { iconImage(named: "sat_array") }
    static var settlementSmall: UIImage { iconImage(named: "settlement_small") }
    static var vault: UIImage { iconImage(named: "vault") }
    static var water: UIImage { iconImage(named: "water") }
    
    static func icon(for locationType: LocationType) -> UIImage {
        switch locationType {
        case .building:
            return Icons.building
        case .dome:
            return Icons.dome
        case .factory:
            return Icons.factory
        case .farm:
            return Icons.farm
        case .fillingStation:
            return Icons.fillingStation
        case .junkyard:
            return Icons.junkyard
        case .military:
            return Icons.military
        case .monument:
            return Icons.monument
        case .pondLake:
            return Icons.pondLake
        case .quarry:
            return Icons.quarry
        case .railRoad:
            return Icons.railRoad
        case .ruins:
            return Icons.ruins
        case .sanctuaryHills:
            return Icons.sanctuaryHills
        case .satelliteArray:
            return Icons.satelliteArray
        case .settlementSmall:
            return Icons.settlementSmall
        case .vault:
            return Icons.vault
        case .water:
            return Icons.water
        }
    }
    
    private static func iconImage(named name: String) -> UIImage {
        UIImage(named: "icon_\(name)")!
    }
}
