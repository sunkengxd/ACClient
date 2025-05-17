import Foundation

enum NetworkProtocol: String, Identifiable, CaseIterable, Sendable, Equatable {
    case http
    case https
    
    var id: Self { self }
    
    var systemImage: String {
        switch self {
        case .http:
            return "lock.open"
        case .https:
            return "lock"
        }
    }
}
