import SwiftUI


struct AuthInfoText: View {
    @EnvironmentObject
    var docViewModel: DocumentationViewModel
    
    var body: some View {
        VStack{
            Text("OperatorID: \(docViewModel.documentationInfo.operatorEmail)")
                .font(.largeTitle)
                .foregroundStyle(Color.belman_blue)
            Text("Order number: \(docViewModel.documentationInfo.orderNumber)")
                .font(.largeTitle)
                .foregroundStyle(Color.belman_blue)
        }
    }
}


struct SavedPhotosScrollView: View {
    @Binding var photoItemArray: [PhotoItem]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(photoItemArray) { item in
                    VStack {
                        Text("\(item.side)")
                            .font(.headline)
                            .foregroundStyle(Color.belman_blue)
                        
                        Image(uiImage: item.uiImage!)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(8)
                        
                    }
                }
            }
        }
//        .padding(.top, 50)
    }
}
