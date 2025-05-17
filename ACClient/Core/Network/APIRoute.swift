import Foundation

struct APIRoute {
    let baseURL: String
    
    var notes: URL {
        URL(string: baseURL + "/notes")!
    }
    
    func note(id: UUID) -> URL {
        URL(string: baseURL + "/notes/" + id.uuidString)!
    }
}
