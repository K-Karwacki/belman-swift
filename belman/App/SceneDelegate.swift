import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Logger.shared.log("SceneDelegate: willConnectTo called at \(Date())")
        
        guard let windowScene = (scene as? UIWindowScene) else {
            Logger.shared.log("SceneDelegate: Failed to cast scene to UIWindowScene")
            return
        }
        
        Logger.shared.log("SceneDelegate: Creating UIWindow")
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        Logger.shared.log("SceneDelegate: Setting up AuthView ")
        let documentationViewModel = DocumentationViewModel()
        let authView = AuthView()
//            authView.environmentObject(documentationViewModel)
        
        Logger.shared.log("SceneDelegate: Creating UIHostingController")
        let hostingController = UIHostingController(rootView: authView)
        
        Logger.shared.log("SceneDelegate: Setting rootViewController")
        window.rootViewController = hostingController
        
        Logger.shared.log("SceneDelegate: Making window key and visible")
        window.makeKeyAndVisible()
        
        // Fallback UI test
        Logger.shared.log("SceneDelegate: Verifying window setup")
        if window.rootViewController == nil {
            Logger.shared.log("SceneDelegate: ERROR - rootViewController is nil")
            window.rootViewController = UIViewController() // Fallback to avoid black screen
            window.rootViewController?.view.backgroundColor = .red
        }
    }
}
