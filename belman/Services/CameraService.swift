import AVFoundation
import SwiftUI
import Combine

// CameraService 

class CameraService: NSObject, AVCapturePhotoCaptureDelegate {
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "dk.easv.belman.captureSessionQueue")
    private let output = AVCapturePhotoOutput()
    
    @Published var image: UIImage?
    @Published var error: Error?
    @Published var isCameraAvailable: Bool = false
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
    override init() {
        super.init()
        configureCaptureSession()
    }
    
    func configureCaptureSession() {
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .high
            
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                DispatchQueue.main.async {
                    self.error = CameraError.deviceNotFound
                }
                return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: camera)
                guard self.session.canAddInput(input) else {
                    DispatchQueue.main.async {
                        self.error = CameraError.inputNotSupported
                    }
                    return
                }
                self.session.addInput(input)
                
                guard self.session.canAddOutput(self.output) else {
                    DispatchQueue.main.async {
                        self.error = CameraError.outputNotSupported
                    }
                    return
                }
                self.session.addOutput(self.output)
                
                self.session.commitConfiguration()
                
                DispatchQueue.main.async {
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                    self.previewLayer?.videoGravity = .resizeAspectFill
                    self.isCameraAvailable = true
                }
                
                self.session.startRunning()
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isCameraAvailable = false
                }
            }
        }
    }
    
    func stopCaptureSession(){
        sessionQueue.async {
            if(self.session.isRunning){
                self.session.stopRunning()
                Logger.shared.log("Capture Session closed")
            }
            return
        }
    }
    
    func startCaptureSession(){
        sessionQueue.async{
            if(!self.session.isRunning){
                self.session.startRunning()
                Logger.shared.log("Capture Session started running.")
            }
        }
    }
    
    func takePhoto() {
        guard isCameraAvailable else {
            error = CameraError.cameraNotReady
            return
        }
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            DispatchQueue.main.async {
                self.error = error
            }
            return
        }
        guard let data = photo.fileDataRepresentation(),
              let uiImage = UIImage(data: data) else {
            DispatchQueue.main.async {
                self.error = CameraError.imageProcessingFailed
            }
            return
        }
        DispatchQueue.main.async {
            self.image = uiImage
        }
    }
}

enum CameraError: Error, LocalizedError {
    case deviceNotFound
    case inputNotSupported
    case outputNotSupported
    case cameraNotReady
    case imageProcessingFailed
    
    var errorDescription: String? {
        switch self {
        case .deviceNotFound: return "No camera device found."
        case .inputNotSupported: return "Camera input not supported."
        case .outputNotSupported: return "Photo output not supported."
        case .cameraNotReady: return "Camera is not ready."
        case .imageProcessingFailed: return "Failed to process captured image."
        }
    }
}
