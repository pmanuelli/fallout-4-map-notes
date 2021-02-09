import Foundation

struct UserDefaultsLocationRepository: LocationRepository {
    
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func add(_ location: Location) {
        
        var locations = readAll()
        locations.append(location)
        
        userDefaults.set(encode(locations), forKey: "locations")
    }
    
    func readAll() -> [Location] {
        guard let data = userDefaults.object(forKey: "locations") as? Data else { return [] }
        
        return decode(data)
    }
    
    func update(_ location: Location) {
        
        var locations = readAll()
    
        guard let index = locations.firstIndex(where: { $0.id == location.id }) else { return }
        
        locations[index] = location
        
        userDefaults.set(encode(locations), forKey: "locations")
    }
    
    private func encode(_ locations: [Location]) -> Data? {
        try? encoder.encode(locations.map { LocationDTO.fromLocation($0) })
    }
    
    private func decode(_ data: Data) -> [Location] {
        guard let decoded = try? decoder.decode([LocationDTO].self, from: data) else { return [] }
        return decoded.compactMap { $0.toLocation() }
    }
}

private struct LocationDTO: Codable {
    
    let id: String
    let type: String
    let name: String
    let notes: String
    let coordinateX: Double
    let coordinateY: Double
    
    static func fromLocation(_ location: Location) -> LocationDTO {
        LocationDTO(id: location.id,
                    type: location.type.rawValue,
                    name: location.name,
                    notes: location.notes,
                    coordinateX: location.coordinates.x,
                    coordinateY: location.coordinates.y)
    }
    
    func toLocation() -> Location? {
        guard let type = LocationType(rawValue: type) else { return nil }
        
        return Location(id: id,
                        type: type,
                        name: name,
                        notes: notes,
                        coordinates: Coordinates(x: coordinateX, y: coordinateY))
    }
}

extension LocationType: Codable { }
