import Foundation

class InMemoryLocationRepository: LocationRepository {

    func add(_ location: Location) {
        
    }
    
    func readAll() -> [Location] {
        [Location(id: UUID().uuidString, type: .junkyard, name: "Location 1", notes: "Some 1 notes", coordinates: Coordinates(x: 0.5, y: 0.5)),
         Location(id: UUID().uuidString, type: .junkyard, name: "Location 2", notes: "Some 2 notes", coordinates: Coordinates(x: 0.2, y: 0.2)),
         Location(id: UUID().uuidString, type: .junkyard, name: "Location 3", notes: "Some 3 notes", coordinates: Coordinates(x: 0.1, y: 0.1)),
         Location(id: UUID().uuidString, type: .dome, name: "Location 4", notes: "Some other 4 notes", coordinates: Coordinates(x: 0.4, y: 0.4))]
    }
    
    func update(_ location: Location) {
        
    }
}
