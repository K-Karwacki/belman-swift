import SwiftUI

struct CameraView: View {
    @EnvironmentObject var documentationViewModel: DocumentationViewModel
    
    @StateObject private var cameraViewModel = CameraViewModel()
    
    @State private var showingPhoto = false
    
    @State private var currentCaptureStep: String?
    
    private var captureSteps = ["Top", "Left", "Front", "Right", "Back"]
    

    var body: some View {
        
        ZStack {
            if cameraViewModel.previewLayer != nil {
                CameraPreviewView(previewLayer: $cameraViewModel.previewLayer)
                    .ignoresSafeArea()
                    .background(Color.black)
                    .onAppear {
                        Logger.shared.log("CameraView appeared, previewLayer exists")
                    }
            } else {
                Color.black
                    .overlay(
                        Text("Camera unavailable. Please use a physical device.")
                            .foregroundColor(.white)
                            .font(.title2)
                    )
                    .ignoresSafeArea()
            }
            
            VStack {
                if let currentCaptureStep {
                    Text("\(currentCaptureStep)")
                }
//                if let nextPosition = captureSteps.first(where: { !documentationViewModel.photoDict.keys.contains($0) }) {
////                    currentCaptureStep = nextPosition
//                    Text("Position: \(nextPosition)")
//                        .font(.largeTitle)
//                        .foregroundStyle(Color.belman_blue)
//                        .padding(.top, 20)
//                } else {
//                    currentCaptureStep = "Extra"
//                    Text(currentCaptureStep)
//                        .font(.title2)
//                        .foregroundStyle(.green)
//                        .padding(.top, 20)
//                }
                
                Spacer()
            }
            .onAppear{
                updateStep()
            }
            HStack {
                Spacer()
                
                Button(action: {
                    cameraViewModel.takePhoto()
                }) {
                    Text("")
                        .font(.largeTitle)
                        .padding(27)
                        .background(cameraViewModel.isCameraAvailable ? Color.white : Color.gray)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                }
                .disabled(!cameraViewModel.isCameraAvailable)
                .padding()

            }
        }
        .sheet(isPresented: $showingPhoto) {
            VStack{
                PhotoView(
                    onSave:{
                        self.documentationViewModel.addPhotoItem(photoItem: PhotoItem(image: self.cameraViewModel.capturedImage!, info: currentCaptureStep!))

                        updateStep()
                        showingPhoto = false
                    },
                    onRetake:{
                        showingPhoto = false
                    }
                )
                    .environmentObject(cameraViewModel)
                    .environmentObject(documentationViewModel)
            }
        }
        .onChange(of: cameraViewModel.capturedImage) { _, newValue in
            showingPhoto = newValue != nil
        }
        .onChange(of: cameraViewModel.isCameraAvailable) { _, available in
            Logger.shared.log("Camera available: \(available)")
        }
    }
    
    func updateStep(){
        var i: Int = 0
        if let step = captureSteps.first(where: { step in
            !documentationViewModel.photoItemArray.contains(where: { $0.side == step })
        }) {
            currentCaptureStep = step
        } else {
            currentCaptureStep = "Extra\(i += 1)"
        }
    }
    

}

#Preview{
    CameraView()
}
