import SwiftUI

struct ContentView: View {
    @State private var router = Router()
    var body: some View {
        RoutedContent(router: router) {
            AuthorizationView()
                .navigationDestination(for: AuthorizationData.self) { data in
                    NoteScreen(authorizationData: data)
                }
        }
    }
}

#Preview {
    ContentView()
}
