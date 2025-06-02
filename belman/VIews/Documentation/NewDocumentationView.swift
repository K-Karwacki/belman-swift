import SwiftUI

struct NewDocumentationView: View{
    @EnvironmentObject var documentationViewModel: DocumentationViewModel
    @EnvironmentObject var router: NavigationRouter
    
    @State private var uploadSuccessful: Bool = false
    @State private var alertMsg: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    
    @State private var positions = ["front", "left", "right", "top", "bottom"]
    
    var body: some View{
        ZStack(alignment: .top){
            Color.appBackground
                .ignoresSafeArea() // Extends to all edges
            
            VStack{
                AuthInfoText(docViewModel: _documentationViewModel)
                
                Button("Open camera") {
                    router.go(to: .camera)
                }
                .buttonStyle(.bordered)
                .font(.title2)
                
                
                if(!documentationViewModel.photoItemArray.isEmpty){
                    SavedPhotosScrollView(photoItemArray: $documentationViewModel.photoItemArray)
                }
                else{
                    Text("No photos taken.")
                        .foregroundStyle(Color.gray)
                        .font(.system(size: 20))
                        .padding(.top, 200)
                }
                
                Button("submit") {
                    isLoading = true
                    if(documentationViewModel.photoItemArray.count < 5){
                        alertMsg = "5 photos should be taken"
                        showAlert = true
                        isLoading = false
                        return
                    }
                    
//                    let doc = PhotoDocumentation(orderNumber: documentationViewModel.orderNumber!, operatorID: documentationViewModel.operatorID!, status: "PENDING", date: ISO8601DateFormatter().string(from: Date()), side: "side")
                    Task{
                        alertMsg = await self.documentationViewModel.uploadDocumentation() ? "Success" : "Failed"
//                        let success = await RESTService.uploadPhotoDocumentation(doc: doc, images: documentationViewModel.photos)
//                        alertMsg = success ? "Upload successful" : "Failed to upload"
//                        documentationViewModel.resetModel()
                        isLoading = false
                        showAlert = true
                    }
                }
                .buttonStyle(.bordered)
                .disabled(isLoading)
                .font(.title2)
                
            }
        }
        .alert("Upload Result", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                

            }
        } message: {
            Text(alertMsg)
        }
    }
}

#Preview {
    NewDocumentationView()
        .environmentObject(DocumentationViewModel())
        .environmentObject(NavigationRouter())

}

