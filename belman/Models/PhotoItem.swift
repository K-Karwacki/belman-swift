import SwiftUI
import Foundation

struct PhotoItem: Hashable, Codable, Identifiable{
    let id: UUID
    var imageData: Data?
    var side: String
    
    init(imageData: Data, info: String) {
        self.id = UUID()
        self.imageData = imageData
        self.side = info
    }
    
    init(image: UIImage, info:String){
        self.id = UUID()
        self.imageData = image.pngData()!
        self.side = info
    }
    
    var uiImage: UIImage?{
        UIImage(data: imageData!)
    }
}
