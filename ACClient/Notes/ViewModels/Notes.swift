import Observation
import Foundation

@MainActor
@Observable
final class Notes {
    private(set) var error: Error?
    private(set) var data: [Note] = []
    private let http = Client()

    func fetch() async {
        do {
            self.data = try await http.get(.notes)
        } catch let error {
            self.error = error
        }
    }
    
    func create(name: String) async {
        do {
            let note: Note = try await http.post(
                to: .notes,
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
        do {
            for index in offsets {
                let note = data[index]
                try await http.delete(.note(id: note.id))
                data.remove(atOffsets: [index])
            }
        } catch let error {
            self.error = error
        }
    }
}
