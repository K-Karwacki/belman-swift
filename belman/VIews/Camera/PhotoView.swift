import SwiftUI

struct PhotoView: View {
    @EnvironmentObject var viewModel: CameraViewModel

    var body: some View {
        VStack{
            if viewModel.capturedImage != nil {
                Image(uiImage: viewModel.capturedImage!)
                    .resizable()
                    .scaledToFit()
                    .background(Color.black)
                    .ignoresSafeArea()
            }else{
                Text("No image")
            }
            
            
            HStack{
                Button("Retake"){
//                    showingPhoto = false
//                    viewModel.showingPhoto = false;
                }
                Button(action:{
//                            self.documentationViewModel.addPhoto("test", self.viewModel.capturedImage)
//                            Logger.shared.log("Photo accepted: ")
//                            showingPhoto = false
                }){
                    Text("Lala")
                }
//                        Button("Save"){
//
//                        }
            }
        }
        
    }
}
