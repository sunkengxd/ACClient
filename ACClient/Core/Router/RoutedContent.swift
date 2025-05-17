import SwiftUI

struct RoutedContent<Content: View>: View {
    @State var router: Router
    @ViewBuilder let content: () -> Content
    
    init(router: Router, @ViewBuilder content: @escaping () -> Content) {
        self.router = router
        self.content = content
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content()
                .environment(\.router, router)
        }
    }
}
