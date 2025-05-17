import Foundation

struct Note: Sendable, Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let name: String
}
