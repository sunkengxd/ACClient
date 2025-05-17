import Foundation

final class Client: Sendable {

    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    private func validate(_ response: URLResponse) throws(URLError) {
        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode
        else {
            throw URLError(.badServerResponse)
        }
    }

    func get<Value: Decodable>(
        _ url: URL,
        decoder: JSONDecoder = .init()
    ) async throws -> Value {
        let (data, response) = try await urlSession.data(from: url)
        try validate(response)
        return try decoder.decode(Value.self, from: data)
    }
    
    func post<Value: Encodable, ReturnValue: Decodable>(
        to url: URL,
        value: Value,
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init()
    ) async throws -> ReturnValue {
        let input = try encoder.encode(value)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = input
        
        let (output, response) = try await urlSession.data(for: request)
        try validate(response)
        
        return try decoder.decode(ReturnValue.self, from: output)
    }
    
    func delete(_ url: URL) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await urlSession.data(for: request)
        try validate(response)
    }
}
