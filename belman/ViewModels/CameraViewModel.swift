import Combine
import SwiftUI
import AVFoundation

@MainActor
class CameraViewModel: ObservableObject {
    @Published var collectionOfCapturedImages: Set<UIImage>?
    @Published var capturedImage: UIImage?
    @Published var errorMessage: String?
    @Published var isCameraAvailable: Bool = false
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
    private let cameraService: CameraService
    private var cancellables = Set<AnyCancellable>()
    
    // Initialize CameraViewModel with CameraService
    init(cameraService: CameraService = CameraService()) {
        self.cameraService = cameraService
        setupBindings()
    }
    
    func closeCamera(){
        guard cameraService.isCameraAvailable else{
            errorMessage = "Camera already closed"
            return
        }
        cameraService.stopCaptureSession();
    }
    
    func takePhoto() {
        guard cameraService.isCameraAvailable else {
            errorMessage = "Camera is not available."
            return
        }
        cameraService.takePhoto()
    }
    
    private func setupBindings() {
        cameraService.$image
            .receive(on: DispatchQueue.main)
            .assign(to: &$capturedImage)
        
        cameraService.$error
            .map { $0?.localizedDescription }
            .receive(on: DispatchQueue.main)
            .assign(to: &$errorMessage)
        
        cameraService.$isCameraAvailable
            .receive(on: DispatchQueue.main)
            .assign(to: &$isCameraAvailable)
        
        cameraService.$previewLayer
            .receive(on: DispatchQueue.main)
            .assign(to: &$previewLayer)
    }
}
