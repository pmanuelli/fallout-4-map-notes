import Foundation

struct UserDefaultsLocationRepository: LocationRepository {
    
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func create(_ location: Location) {
        
        let locations = readAll() + [location]
        storeLocations(locations)
    }
    
    func readAll() -> [Location] {
        guard let data = userDefaults.object(forKey: "locations") as? Data else { return [] }
        
        return decode(data)
    }
    
    func update(_ location: Location) {
        
        var locations = readAll()
    
        guard let index = locations.firstIndex(where: { $0.id == location.id }) else { return }
        
        locations[index] = location
        
        storeLocations(locations)
    }
    
    func delete(_ locationId: Location.Id) {
        
        let locations = readAll().filter { $0.id != locationId}
        storeLocations(locations)
    }
    
    private func encode(_ locations: [Location]) -> Data? {
        try? encoder.encode(locations.map { LocationDTO.fromLocation($0) })
    }
    
    private func decode(_ data: Data) -> [Location] {
        guard let decoded = try? decoder.decode([LocationDTO].self, from: data) else { return [] }
        return decoded.compactMap { $0.toLocation() }
    }
    
    private func storeLocations(_ locations: [Location]) {
        userDefaults.set(encode(locations), forKey: "locations")
    }
}

private struct LocationDTO: Codable {
    
    let id: String
    let coordinateX: Double
    let coordinateY: Double
    let type: String
    let name: String
    let notes: String
    let features: [String]?

    static func fromLocation(_ location: Location) -> LocationDTO {
        LocationDTO(id: location.id,
                    coordinateX: location.coordinates.x,
                    coordinateY: location.coordinates.y,
                    type: location.type.rawValue,
                    name: location.name,
                    notes: location.notes,
                    features: location.features.map { $0.rawValue })
    }
    
    func toLocation() -> Location? {
        guard let type = LocationType(rawValue: type) else { return nil }
        
        return Location(id: id,
                        coordinates: Coordinates(x: coordinateX, y: coordinateY),
                        type: type,
                        name: name,
                        notes: notes,
                        features: (features ?? []).compactMap { Location.Feature(rawValue: $0) })
    }
}

extension LocationType: Codable { }
extension Location.Feature: Codable { }
