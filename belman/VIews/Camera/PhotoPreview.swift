import SwiftUI

struct PhotoView: View {
    @EnvironmentObject var cameraViewModel: CameraViewModel
    @EnvironmentObject var docViewModel: DocumentationViewModel
    
    let onSave:() -> Void
    let onRetake:() -> Void

    var body: some View {
        VStack{
            if cameraViewModel.capturedImage != nil {
                Image(uiImage: cameraViewModel.capturedImage!)
                    .resizable()
                    .scaledToFit()
                    .background(Color.black)
                    .ignoresSafeArea()
            }else{
                Text("No image")
            }
            
            
            HStack{
                Button("Retake"){
                    onRetake()
                }
                .buttonStyle(.bordered)
                .padding()
                .font(.title2)
            
                
                
                Button("Save"){
                    onSave()
                }
                .buttonStyle(.bordered)
                .padding()
                .font(.title2)
                .foregroundStyle(Color.gelman_green)
            
            }
        }
        
    }
}
