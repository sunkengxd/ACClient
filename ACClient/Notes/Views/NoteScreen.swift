import SwiftUI

struct NoteScreen: View {

    @State private var notes: Notes

    @State private var showError = false
    @State private var newNote = ""

    init(authorizationData: AuthorizationData) {
        notes = .init(authorizationData: authorizationData)
    }
    
    var body: some View {
        List {
            if let error = notes.error {
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
            }

            Section("New") {
                TextField("Name", text: $newNote)
                    .onSubmit {
                        Task {
                            await notes.create(name: newNote)
                            newNote = ""
                        }
                    }
            }
            Section("Notes") {
                ForEach(notes.data) { note in
                    Text(note.name)
                }
                .onDelete { indexSet in
                    Task {
                        await notes.delete(at: indexSet)
                    }
                }
                if notes.data.isEmpty {
                    Text("Empty")
                }
            }
        }
        .animation(.default, value: notes.data)
        .animation(.default, value: notes.data.isEmpty)
        .refreshable {
            await notes.fetch()
        }
        .task {
            await notes.fetch()
        }
        .navigationTitle("Todos")
    }
}

#Preview {
    let data = AuthorizationData(networkProtocol: .http, baseURL: "localhost:8080")
    NavigationStack {
        NoteScreen(authorizationData: data)
    }
}
