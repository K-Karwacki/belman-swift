import SwiftUI
import GoogleSignIn

struct AuthView: View {
    @State private var operatorID = ""
    @State private var orderNumber = ""
    @State private var errorMsg = ""
    @State private var showError: Bool = false
    
    @FocusState private var focusedField: Field?
    
    @EnvironmentObject var documenatationViewModel: DocumentationViewModel
    @EnvironmentObject var router: NavigationRouter
    
    enum Field {
        case operatorID
        case orderNumber
    }
    

    var body: some View {
        ZStack{
            Color.appBackground
                .ignoresSafeArea() // Extends to all edges
            
            VStack(spacing: 80) {
                
                Text("Photo Documentation")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
//                    .lineSpacing(7)
                    .font(.custom("Arial Hebrew", size: 35))
                    .foregroundStyle(Color.belman_blue)
                
                
                VStack(spacing: 29){
                    
                    // OperatorID input container
                    VStack(alignment: .leading){
                        Text("Operator Email/ID")
                            .font(.headline)
                            .foregroundStyle(Color.belman_50_gray)
                            .padding(.leading, 15)
                            .padding(.bottom, 10)
//                            .position(.zero)
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
                                .stroke(focusedField == .operatorID ? Color.gelman_green : Color.belman_blue, lineWidth: 1)
                        )
                    }
                    
                    
                    
                    
                    // Order Number input container
                    VStack(alignment: .leading){
                        Text("Order number")
                            .font(.headline)
                            .foregroundStyle(Color.belman_50_gray)
                            .padding(.leading, 15)
                            .padding(.bottom, 10)
                        HStack {
                            Image(systemName: "document.fill")
                                .foregroundColor(.gray)
                            
                            TextField("Order number", text: $orderNumber)
                                .font(.body)
                                .foregroundStyle(.gray)
                                .padding()
                                .cornerRadius(8)
                                .focused($focusedField, equals: .orderNumber)
                        }
                        .padding(.horizontal)
                        .background(Color(hex: "#f2f2f2"))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(focusedField == .orderNumber ? Color.gelman_green : Color.belman_blue, lineWidth: 1)
                        )
                    }
                    
                }
   
                Button("Start Documentation"){
                    do{
                        // Validate fields are not empty
                        try validateTextFields()
                        
                        // Update model
                        documenatationViewModel.setAuthInfo(orderNumber: orderNumber, operatorID: operatorID)
                        
                        // Switch view
                        router.go(to: .main)
                    }catch TextFieldError.emptyField(let msg){
                        errorMsg = msg
                        showError = true
                    }catch{
                        errorMsg = "Something went wrong"
                        showError = true
                    }
                }
                .font(.title2)
                .buttonStyle(.bordered)
                
            }
            .padding()
            .frame(width: 400)
        }
        .alert(isPresented: $showError){
            Alert(title: Text("Error"), message: Text(errorMsg), dismissButton: .default(Text("OK")))
        }
    }
    
    func validateTextFields() throws {
        guard !orderNumber.isEmpty else {
            throw TextFieldError.emptyField("Order number is empty")
        }
        guard !operatorID.isEmpty else {
            throw TextFieldError.emptyField("Operator ID is empty")
        }
    }
    
}
    


enum TextFieldError: Error, LocalizedError {
    case emptyField(String)
    
    var errorDescription: String?{
        switch self{
        case .emptyField(let message):
            return message
        }
    }
}

#Preview{
    AuthView()
        .environmentObject(DocumentationViewModel())
}
