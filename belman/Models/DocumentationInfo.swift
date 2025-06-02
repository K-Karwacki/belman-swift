import Foundation

struct DocumentationInfo: Codable {
    var orderNumber: String = "Order number"
    var operatorEmail: String = "Operator ID"
    var status: String = "PENDING"
    var date: String = ISO8601DateFormatter().string(from: Date())
}
