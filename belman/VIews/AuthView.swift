import SwiftUI

struct AuthView: View {
    @State private var operatorID = ""
    @State private var orderNumber = ""
    @State private var errorMsg = ""
    @FocusState private var focusedField: Field?
    
    @EnvironmentObject private var documenatationViewModel: DocumentationViewModel
    
    enum Field {
        case operatorID
        case orderNumber
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.appBackground
                    .ignoresSafeArea() // Extends to all edges
                
                VStack(spacing: 60) {

                    Text("Photo Documentation")
                        .multilineTextAlignment(.center)
                        .lineSpacing(7)
                        .font(.custom("Arial Hebrew", size: 35))
                        .foregroundStyle(Color.belman_blue)

                    
                    VStack(spacing: 29){
                        HStack{
                            Image(systemName: "person.fill")
                                .foregroundStyle(.gray)
                            TextField("Operator ID", text: $operatorID)
                                .font(.body)
                                .foregroundStyle(.gray)
                                .padding()
                                .cornerRadius(8)
            //                    .textContentType(.none)
                                .autocapitalization(.none)
                                .focused($focusedField, equals: .operatorID)
                                
                
                        }
                        .padding(.horizontal)
                        .background(Color(hex: "#f2f2f2"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.belman_blue, lineWidth: 1)
                        )
                        
                        
                        
                        // Order Number input container
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            
                            TextField("Order number", text: $orderNumber)
                                .font(.body)
                                .foregroundStyle(.gray)
                                .padding()
                                .focused($focusedField, equals: .orderNumber)
                        }
                        .padding(.horizontal)
                        .background(Color(hex: "#f2f2f2"))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.belman_blue, lineWidth: 1)
                        )
                    }
                    Text(errorMsg).font(.subheadline)
                        .foregroundStyle(Color.red)
                    // Start documentation button
                    Button(action:{
                        if(operatorID.isEmpty || orderNumber.isEmpty){
                            errorMsg = "Please provide Operator ID and Order Number."
                        }else{
                            errorMsg = ""
                            
                        }
                        
                    }){
                        Text("Start documentation")
                            .font(.title2)
                            .padding()
                            .background(Color.belman_blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .background(
                        NavigationLink(destination: DocumentationCreatorView(), label:{
//                            Text("lala")
                        }).disabled(operatorID.isEmpty || orderNumber.isEmpty)
                    )
        
                
                    
                }
                .padding()
                .frame(width: 400)
            }
        }
    }
}

#Preview{
    AuthView()
        .environmentObject(DocumentationViewModel())
}
