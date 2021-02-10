import Foundation

class UUIDLocationIdGenerator: LocationIdGenerator {
    
    func generate() -> Location.Id {
        UUID().uuidString
    }
}
