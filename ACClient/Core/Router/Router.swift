import Observation
import SwiftUI

@Observable
final class Router {
    var path: NavigationPath = .init()
}
