import Observation
import Foundation

@MainActor
@Observable
final class Notes {
    private(set) var error: Error?
    private(set) var data: [Note] = []
    private let http: Client
    private let route: APIRoute

    init(
        authorizationData: AuthorizationData,
        client: Client = .init()
    ) {
        self.route = .init(baseURL: authorizationData.joined)
        self.http = client
    }
    
    func fetch() async {
        do {
            error = nil
            self.data = try await http.get(route.notes)
        } catch let error {
            self.error = error
        }
    }
    
    func create(name: String) async {
        error = nil
        do {
            let note: Note = try await http.post(
                to: route.notes,
                value: [
                    "name": name
                ]
            )
            data.append(note)
        } catch let error {
            self.error = error
        }
    }
    
    func delete(at offsets: IndexSet) async {
        error = nil
        do {
            for index in offsets {
                let note = data[index]
                try await http.delete(route.note(id: note.id))
                data.remove(atOffsets: [index])
            }
        } catch let error {
            self.error = error
        }
    }
}
