import SwiftUI

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var showingPhoto = false
    
    var body: some View {
        ZStack {
            if viewModel.previewLayer != nil {
                CameraPreview(previewLayer: $viewModel.previewLayer)
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
                Spacer()
                
                Button(action: {
                    viewModel.takePhoto()
                }) {
                    Text("Take Photo")
                        .font(.title2)
                        .padding()
                        .background(viewModel.isCameraAvailable ? Color.white : Color.gray)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                }
                .disabled(!viewModel.isCameraAvailable)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showingPhoto) {
            if let image = viewModel.capturedImage {
                PhotoView(image: image)
            }
        }
        .alert(item: Binding(
            get: { viewModel.errorMessage.map { ErrorMessage(message: $0) } },
            set: { _ in viewModel.errorMessage = nil }
        )) { error in
            Alert(
                title: Text("Camera Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: viewModel.capturedImage) { _, newValue in
            showingPhoto = newValue != nil
        }
        .onChange(of: viewModel.isCameraAvailable) { _, available in
            Logger.shared.log("Camera available: \(available)")
        }
    }
}

struct ErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}

#Preview{
    CameraView()
}
