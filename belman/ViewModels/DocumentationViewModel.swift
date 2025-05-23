import SwiftUI

class DocumentationViewModel: ObservableObject {
    @State private var photos: [PhotoItem] = []
    @Published var orderNumber: String?
    @Published var operatorID: String?
    
    
    
    func setData(orderNumber: String, operatorID: String){
        self.orderNumber = orderNumber
        self.operatorID = operatorID
    }
    
    func addPhoto(photo: UIImage, position: String){
        DispatchQueue.main.async {
            let newPhoto = PhotoItem(position: position, imageData: photo.pngData()!)
            self.photos.append(newPhoto)
        }
    
    }
}
