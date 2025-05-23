import Foundation
import AuthenticationServices
// MARK: - Google Cloud API Models

struct GDriveFile: Codable {
    let id: String
    let name: String
    let mimeType: String
}

// MARK: - CloudManager

class CloudManager {
    private let session = URLSession.shared
    private let baseURL = "https://www.googleapis.com/drive/v3"
    private let uploadURL = "https://www.googleapis.com/upload/drive/v3/files"
    private let accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    // MARK: - Create Folder

    func createFolder(name: String, parentId: String? = nil, completion: @escaping (Result<GDriveFile, Error>) -> Void) {
        var params: [String: Any] = [
            "name": name,
            "mimeType": "application/vnd.google-apps.folder"
        ]
        if let parentId = parentId {
            params["parents"] = [parentId]
        }

        guard let url = URL(string: "\(baseURL)/files") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            do {
                let file = try JSONDecoder().decode(GDriveFile.self, from: data)
                completion(.success(file))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - List Files in Folder

    func listFiles(inFolder folderId: String, completion: @escaping (Result<[GDriveFile], Error>) -> Void) {
        let query = "parents='\(folderId)'"
        guard let url = URL(string: "\(baseURL)/files?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&fields=files(id,name,mimeType)") else { return }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            do {
                let result = try JSONDecoder().decode([String: [GDriveFile]].self, from: data)
                completion(.success(result["files"] ?? []))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Download File

    func downloadFile(fileId: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/files/\(fileId)?alt=media") else { return }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
class GoogleOAuthManager: NSObject {
    private let clientId = "PASTE CLIENT ID HERE"
    private let redirectURI = "com.yourapp.oauth://callback"
    private let scope = "https://www.googleapis.com/auth/drive"
    
    func authenticate(completion: @escaping (Result<String, Error>) -> Void) {
        let authURL = buildAuthURL()
        
        guard let url = URL(string: authURL) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }
        
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: "com.yourapp.oauth") { callbackURL, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let callbackURL = callbackURL,
                  let code = self.extractAuthCode(from: callbackURL) else {
                completion(.failure(NSError(domain: "NoAuthCode", code: 0)))
                return
            }
            
            self.exchangeCodeForToken(code: code, completion: completion)
        }
        
        session.presentationContextProvider = self
        session.start()
    }
    
    private func buildAuthURL() -> String {
        let baseURL = "https://accounts.google.com/o/oauth2/v2/auth"
        let params = [
            "client_id": clientId,
            "redirect_uri": redirectURI,
            "response_type": "code",
            "scope": scope,
            "access_type": "offline"
        ]
        
        let queryString = params.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
        
        return "\(baseURL)?\(queryString)"
    }
    
    private func extractAuthCode(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        return queryItems.first { $0.name == "code" }?.value
    }
    
    private func exchangeCodeForToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let tokenURL = "https://oauth2.googleapis.com/token"
        let params = [
            "client_id": clientId,
            "client_secret": "PASTE CLIENT SECRET HERE",
            "code": code,
            "grant_type": "authorization_code",
            "redirect_uri": redirectURI
        ]
        
        guard let url = URL(string: tokenURL) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyString = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let accessToken = json["access_token"] as? String {
                    completion(.success(accessToken))
                } else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: 0)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension GoogleOAuthManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}

// MARK: - Usage Example
class ViewController: UIViewController {
    private let oauthManager = GoogleOAuthManager()
    private var cloudManager: CloudManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateAndSetupCloudManager()
    }
    
    private func authenticateAndSetupCloudManager() {
        oauthManager.authenticate { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let accessToken):
                    print("Got access token: \(accessToken)")
                    self?.cloudManager = CloudManager(accessToken: accessToken)
                    self?.testCloudOperations()
                    
                case .failure(let error):
                    print("Authentication failed: \(error)")
                }
            }
        }
    }
    
    private func testCloudOperations() {
        guard let cloudManager = cloudManager else { return }
        
        // Create a folder
        cloudManager.createFolder(name: "My Test Folder") { result in
            switch result {
            case .success(let folder):
                print("Created folder: \(folder.name) with ID: \(folder.id)")
                
                // List files in the folder
                cloudManager.listFiles(inFolder: folder.id) { listResult in
                    switch listResult {
                    case .success(let files):
                        print("Found \(files.count) files in folder")
                        
                    case .failure(let error):
                        print("Failed to list files: \(error)")
                    }
                }
                
            case .failure(let error):
                print("Failed to create folder: \(error)")
            }
        }
    }
}

