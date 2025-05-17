struct AuthorizationData: Sendable, Equatable, Hashable {
    let networkProtocol: NetworkProtocol
    let baseURL: String
    
    var joined: String {
        "\(networkProtocol.rawValue)://\(baseURL)"
    }
}
