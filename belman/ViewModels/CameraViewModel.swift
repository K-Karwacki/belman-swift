import Combine
import SwiftUI
import AVFoundation

class CameraViewModel: ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var errorMessage: String?
    @Published var isCameraAvailable: Bool = false
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    @Published var showingPhoto: Bool = false
    
    private let cameraService: CameraService
    
    // Initialize CameraViewModel with CameraService
    init(cameraService: CameraService = CameraService()) {
        self.cameraService = cameraService
        setupBindings()
    }
    
    func takePhoto() {
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
