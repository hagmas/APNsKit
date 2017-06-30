import Foundation

public struct APNsRequest {
    public var port: APNsPort
    public var server: APNsServer
    public var deviceToken: String
    public var payload: APNsPayload
    
    public static let method = "POST"
    
    public init(port: APNsPort, server: APNsServer, deviceToken: String, payload: APNsPayload) {
        self.port = port
        self.server = server
        self.deviceToken = deviceToken
        self.payload = payload
    }
    
    public var url: URL? {
        let urlString = "https://" + server.rawValue + ":\(port.rawValue)" + "/3/device/" + deviceToken
        return URL(string: urlString)
    }
    
    public var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.addValue(UUID().uuidString, forHTTPHeaderField: "apns-id")
        request.httpMethod = APNsRequest.method
        do {
            request.httpBody = try payload.encode()
        } catch {
            print("Encode Error: \(error)")
        }
        return request
    }
}
