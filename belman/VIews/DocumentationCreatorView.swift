import SwiftUI

struct DocumentationCreatorView: View{
//    @Binding var path: NavigationPath
    
    @EnvironmentObject var documentationViewModel: DocumentationViewModel
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View{
        ZStack{
            Text(documentationViewModel.operatorID!)
            Button("Go to New Root") {
//                            path = NavigationPath() // Reset stack
                router.go(to: .camera)
                        }
                        .buttonStyle(.bordered)
                        .padding()
        }
    }
}

#Preview {
//    DocumentationCreatorView()
}
