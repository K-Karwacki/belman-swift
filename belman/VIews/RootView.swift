import SwiftUI

struct RootView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var viewModel: DocumentationViewModel
    
    var body: some View {
        NavigationStack(path: $router.path) {
            AuthView() // First view 
                .navigationDestination(for: AppScreen.self) { screen in
                    router.buildScreen(for: screen)
                }
        }   
    }
}
