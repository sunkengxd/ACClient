import Foundation

extension URL {
    static var base: String { "http:localhost:8080/api/" }
    
    static var notes: URL {
        URL(string: base + "/notes")!
    }
    
    static func note(id: UUID) -> URL {
        URL(string: base + "/notes/\(id.uuidString)")!
    }
}
