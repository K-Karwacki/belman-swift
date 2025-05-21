import SwiftUI

struct PhotoView: View {
    let image: UIImage
    
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .background(Color.black)
                .ignoresSafeArea()
            
        }
        
    }
}
