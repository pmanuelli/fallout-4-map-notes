import Foundation

class UUIDLocationIdGenerator: LocationIdGenerator {
    
    func generate() -> LocationId {
        UUID().uuidString
    }
}
