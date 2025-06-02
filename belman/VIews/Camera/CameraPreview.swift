import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewControllerRepresentable {
    @Binding var previewLayer: AVCaptureVideoPreviewLayer?
    
    func makeUIViewController(context: Context) -> CameraPreviewController {
        let viewController = CameraPreviewController()
        viewController.previewLayer = previewLayer
        Logger.shared.log("CameraPreview: Created UIViewController")
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: CameraPreviewController, context: Context) {

    }
    
    class CameraPreviewController: UIViewController{
        var previewLayer: AVCaptureVideoPreviewLayer?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .black
            
            if let layer = previewLayer {
                view.layer.addSublayer(layer)
            }
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            guard let layer = previewLayer else { return }

            layer.setAffineTransform(.identity)
            layer.setAffineTransform(CGAffineTransform(rotationAngle: currentRotationAngle()))
            layer.frame = view.bounds
            layer.videoGravity = .resizeAspectFill
        }
        
        private func currentRotationAngle() -> CGFloat {
            switch UIDevice.current.orientation {
            case .landscapeLeft:
                return -CGFloat.pi / 2
            case .landscapeRight:
                return CGFloat.pi / 2
            case .portraitUpsideDown:
                return CGFloat.pi
            default:
                return 0
            }
        }
    }
}
