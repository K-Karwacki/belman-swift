import Foundation

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
