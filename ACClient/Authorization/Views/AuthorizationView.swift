import SwiftUI

struct AuthorizationView: View {

    @Environment(\.router) private var router
    @AppStorage("AuthorizationView.selectedProtocol") private
        var selectedProtocol: NetworkProtocol = .http
    @AppStorage("AuthorizationView.baseURL") private var baseURL: String = ""
    @State private var isChecking = false
    @State private var error: Error? = nil

    init() {
    }

    var body: some View {
        Form {
            Section {
                Picker(
                    "Protocol",
                    systemImage: "network",
                    selection: $selectedProtocol
                ) {
                    ForEach(NetworkProtocol.allCases) {
                        Label($0.rawValue, systemImage: $0.systemImage)
                    }
                }
                TextField("Base URL", text: $baseURL)
                    .textCase(.lowercase)
                    .textContentType(.URL)
                    .textInputAutocapitalization(.never)
                if let error {
                    Text(error.localizedDescription)
                        .foregroundStyle(.red)
                }
            }

            if isChecking {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                Button("Confirm", systemImage: "checkmark") {
                    Task { await checkConnection() }
                }
            }
        }
        .animation(.default, value: isChecking)
        .navigationTitle("Authorize")
        .navigationBarTitleDisplayMode(.inline)
    }

    func checkConnection() async {
        isChecking = true
        defer { isChecking = false }
        error = nil
        do {
            let data = AuthorizationData(
                networkProtocol: selectedProtocol,
                baseURL: baseURL
            )

            let url = URL(string: data.joined)!

            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"

            (_, _) = try await URLSession.shared.data(for: request)
            router.path.append(data)
        } catch let error {
            self.error = error
        }
    }
}

#Preview {
    @Previewable @State var router = Router()
    RoutedContent(router: router) {
        AuthorizationView()
    }
}
