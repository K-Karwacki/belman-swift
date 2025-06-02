import Foundation
import UIKit
class RESTService {
    
    static func uploadPhotoDocumentation(documentationInfo: DocumentationInfo, photos: [PhotoItem]) async -> Bool{
        
        let boundary = UUID().uuidString
        let url = URL(string: "http://192.168.8.115:8080/documentations/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // 1. JSON metadata
    
        // Convert metadata to JSON data
        guard let jsonData = try? JSONEncoder().encode(documentationInfo) else {
            print("Failed to encode metadata JSON")
            return false
        }
        
        // 2. Start building body
        var body = Data()
        
        // Add JSON metadata part
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"metadata\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
        body.append(jsonData)
        body.append("\r\n".data(using: .utf8)!)

        // 3. Add image files
        for (index, photoItem) in photos.enumerated() {
            guard let imageData = photoItem.imageData else { continue }
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"files\"; filename=\"photo\(index).png\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"positions\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(photoItem.side)\r\n".data(using: .utf8)!)
        }

        // 4. End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    print("Upload succeeded.")
                    return true
                }
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("Response:\n\(responseString)")
            }

            return false
        } catch {
            print("Upload failed with error: \(error.localizedDescription)")
            return false
        }
    }
}
