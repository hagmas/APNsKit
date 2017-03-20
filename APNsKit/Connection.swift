import Foundation

public class Connection: NSObject, URLSessionDelegate {
    public enum Result {
        case success
        case failure(errorCode: Int, message: String)
    }
    
    let adapter: PKCS12Adapter
    
    public init(p12FileName: String, passPhrase: String) throws {
        self.adapter = try PKCS12Adapter(fileName: p12FileName, passPhrase: passPhrase)
        super.init()
    }
    
    public func send(request: APNsRequest, resultHandler: @escaping (Result) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        if let urlRequest = request.urlRequest {
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if error == nil {
                    // success
                    resultHandler(.success)
                } else {
                    if let data = data,
                        let reason = String(data: data, encoding: .ascii),
                        let httpResponse = response as? HTTPURLResponse {
                        resultHandler(.failure(errorCode: httpResponse.statusCode, message: reason))
                    } else {
                        resultHandler(.failure(errorCode: 0, message: "Unkonwn Error Occured"))
                    }
                }
            })
            task.resume()
        }
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        // Nothing to do
    }
    
#if os(iOS) || os(watchOS) || os(tvOS)
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        // Nothing to do
    }
#endif
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        switch challenge.protectionSpace.authenticationMethod {
        case NSURLAuthenticationMethodClientCertificate:
            let credential = URLCredential(identity: adapter.secIdentity, certificates: [adapter.secCertificate], persistence: .forSession)
            completionHandler(.useCredential, credential)
            
        case NSURLAuthenticationMethodServerTrust:
            if let serverTrust = challenge.protectionSpace.serverTrust {
                let credential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
            }
            
        default:
            break
        }
    }
}
