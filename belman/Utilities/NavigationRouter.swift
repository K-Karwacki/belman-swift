import SwiftUI

@MainActor
class NavigationRouter: ObservableObject {
    @Published var path: [AppScreen] = []

    func go(to screen: AppScreen) {
        path.append(screen)
    }

    func goBack() {
        _ = path.popLast()
    }

    func resetToRoot() {
        path = []
    }
    
    @ViewBuilder
    func buildScreen(for screen: AppScreen) -> some View {
        switch screen {
        case .main:
            NewDocumentationView()
        case .camera:
            CameraView()
        case . auth:
            AuthView()
        }
        
        
    }
}

enum AppScreen: Hashable, Identifiable {
    case main
    case camera
    case auth

    var id: String {
        switch self {
        case .main: return "main"
        case .camera: return "camera"
        case .auth: return "auth"
        
        }
    }
}

