import SwiftUI

class DocumentationViewModel: ObservableObject {
    @Published var orderNumber: String?
    @Published var operatorID: String?
    
    
    
    func setData(orderNumber: String, operatorID: String){
        self.orderNumber = orderNumber
        self.operatorID = operatorID
    }
}
