import SwiftUI

@main
struct MyApp: App {
    @StateObject private var router = NavigationRouter()
    @StateObject private var documentationViewModel = DocumentationViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
                .environmentObject(documentationViewModel)
        }
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgb: UInt64 = 0
        Scanner(string: hex.replacingOccurrences(of: "#", with: "")).scanHexInt64(&rgb)
        
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0
        )
    }
    
    static let belman_blue = Color(hex: "#004b88")
    static let gelman_green = Color(hex: " #338d71")
    static let gelman_dark_gray = Color(hex: " #338d71")
    static let belman_50_gray = Color(hex: "#333535")
    static let appBackground = Color(hex: "#e3e3e3")
}
