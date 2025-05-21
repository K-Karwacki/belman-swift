import Foundation

class Logger {
    static let shared = Logger()
    
    private init() {}
    
    func log(_ message: String) {
        print("[belman] \(message)")
    }
}
