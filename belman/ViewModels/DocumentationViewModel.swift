import SwiftUI

class DocumentationViewModel: ObservableObject {
    @Published var photoItemArray: [PhotoItem] = []
    @Published var documentationInfo = DocumentationInfo()
    
    func setAuthInfo(orderNumber: String, operatorID: String){
        documentationInfo.orderNumber = orderNumber
        documentationInfo.operatorEmail = operatorID
    }
    
    func addPhotoItem(photoItem: PhotoItem){
        self.photoItemArray.append(photoItem)
    }
    
    func resetModel(){
        photoItemArray = []
//        orderNumber = ""
        documentationInfo = DocumentationInfo()
    }
    
    func uploadDocumentation() async -> Bool{
        let success = await RESTService.uploadPhotoDocumentation(documentationInfo: documentationInfo, photos: photoItemArray)
        return success ? true : false
    }
}

