import SwiftUI

struct RootView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var viewModel: DocumentationViewModel
    
    var body: some View {
        NavigationStack(path: $router.path) {
            AuthView() // This is your root view
                .navigationDestination(for: AppScreen.self) { screen in
                    router.buildScreen(for: screen)
                }
        }   
    }
}
