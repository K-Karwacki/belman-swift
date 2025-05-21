import SwiftUI
import AVFoundation
import UIKit

class AppViewModel: ObservableObject {
//    // Camera properties
//    @Published var previewLayer: AVCaptureVideoPreviewLayer?
//    @Published var capturedImage: UIImage?
//    @Published var isCameraAvailable: Bool = false
//    @Published var cameraErrorMessage: String?
//    @Published var textInput: String = ""
//    
//    //  properties
//    @Published var isSignedIn: Bool = false
//    @Published var username: String = ""
//    @Published var authErrorMessage: String?
//    
//    private let cameraService = CameraService()
//    
//    init() {
//        setupCamera()
//    }
//    
//    // Camera methods
//    func setupCamera() {
//        cameraService.configureCaptureSession() { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let previewLayer):
//                    self?.previewLayer = previewLayer
//                    self?.isCameraAvailable = true
//                    Logger.shared.log("AppViewModel: Camera setup successful")
//                case .failure(let error):
//                    self?.isCameraAvailable = false
//                    self?.cameraErrorMessage = error.localizedDescription
//                    Logger.shared.log("AppViewModel: Camera setup failed: \(error)")
//                }
//            }
//        }
//    }
//    
//    func takePhoto() {
//        cameraService.capturePhoto { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let image):
//                    self?.capturedImage = image
//                    Logger.shared.log("AppViewModel: Photo captured")
//                case .failure(let error):
//                    self?.cameraErrorMessage = error.localizedDescription
//                    Logger.shared.log("AppViewModel: Photo capture failed: \(error)")
//                }
//            }
//        }
//    }
//    
////    func uploadToGoogleDrive(presentingViewController: UIViewController) {
////        guard let image = capturedImage else {
////            Logger.shared.log("AppViewModel: No image to upload")
////            return
////        }
////        GoogleDriveService.shared.uploadImage(image, presentingViewController: presentingViewController) { [weak self] result in
////            DispatchQueue.main.async {
////                switch result {
////                case .success:
////                    Logger.shared.log("AppViewModel: Image uploaded to Google Drive")
////                    self?.capturedImage = nil // Clear after upload
////                case .failure(let error):
////                    self?.cameraErrorMessage = error.localizedDescription
////                    Logger.shared.log("AppViewModel: Google Drive upload failed: \(error)")
////                }
////            }
////        }
////    }
//    
//    func resetCameraState() {
//        textInput = ""
//        capturedImage = nil
//        Logger.shared.log("AppViewModel: Camera state reset")
//    }
//    
//    func stopCameraSession() {
//        cameraService.stopCaptureSession()
//        previewLayer = nil
//        isCameraAvailable = false
//        Logger.shared.log("AppViewModel: Camera session stopped")
//    }
//    
//    func restartCameraSession() {
//        setupCamera()
//        Logger.shared.log("AppViewModel: Camera session restarted")
//    }
  
}
