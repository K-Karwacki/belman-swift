import SwiftUI
import Foundation

struct PhotoItem: Identifiable, Hashable, Codable{
    let id: UUID
    let position: String
    let imageData: Data
    
    init(position: String, imageData: Data) {
        self.id = UUID()
        self.position = position
        self.imageData = imageData
    }
    
    var uiImage: UIImage?{
        UIImage(data: imageData)
    }
}
