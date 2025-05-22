import SwiftUI
import AVFoundation

struct CameraPreview: UIViewControllerRepresentable {
    @Binding var previewLayer: AVCaptureVideoPreviewLayer?
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black // Ensure non-nil background
        Logger.shared.log("CameraPreview: Created UIViewController")
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        uiViewController.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        if let previewLayer {
            Logger.shared.log("CameraPreview: Adding preview layer with frame \(uiViewController.view.bounds)")
            previewLayer.frame = uiViewController.view.bounds
            uiViewController.view.layer.addSublayer(previewLayer)
        } else {
            Logger.shared.log("CameraPreview: No preview layer available")
        }
    }
}
