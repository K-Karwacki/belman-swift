import AVFoundation
import SwiftUI
import Combine

// CameraService 

class CameraService: NSObject, AVCapturePhotoCaptureDelegate {
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "dk.easv.belman.captureSessionQueue")
    private let output = AVCapturePhotoOutput()
    private var rotationCoordinator: AVCaptureDevice.RotationCoordinator?
    
    @Published var image: UIImage?
    @Published var error: Error?
    @Published var isCameraAvailable: Bool = false
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
    override init() {
        super.init()
        configureCaptureSession()
    }

    func configureCaptureSession() {
        // Configure capture session on another thread/dispachqueue (session takes time to configure / concurency errors)
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .high
            
            // Try to get the device's camera
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                DispatchQueue.main.async {
                    self.error = CameraError.deviceNotFound
                }
                return
            }
            
            do {
                // Inject camera into capture device input
                let input = try AVCaptureDeviceInput(device: camera)
                
                guard self.session.canAddInput(input) else {
                    DispatchQueue.main.async {
                        self.error = CameraError.inputNotSupported
                    }
                    return
                }
                
                // Add capture device input to the session
                self.session.addInput(input)
                
                guard self.session.canAddOutput(self.output) else {
                    DispatchQueue.main.async {
                        self.error = CameraError.outputNotSupported
                    }
                    return
                }
                
                // Add capture photo output to the session
                self.session.addOutput(self.output)
                
                self.session.commitConfiguration()
                
                // On main thread setup the preview layer (CALayer is tightly integrated with UIKit, and UIKit is not thread safe)
                DispatchQueue.main.async {
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                    self.rotationCoordinator = AVCaptureDevice.RotationCoordinator(device: camera, previewLayer: self.previewLayer)
//                    self.applyCurrentRotation()
                }
                
                self.session.startRunning()
                self.isCameraAvailable = true
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
        if let photoOutputConnection = output.connection(with: .video) {
            let orientation = UIDevice.current.orientation
            switch orientation {
            case .portrait:
                photoOutputConnection.videoRotationAngle = 90
            case .landscapeLeft:
                photoOutputConnection.videoRotationAngle = 0
            default:
                photoOutputConnection.videoRotationAngle = 90
            }
        }
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
    
