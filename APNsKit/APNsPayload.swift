import Foundation

public struct APNsPayload {
    struct APS: Codable {
        struct Alert: Codable {
            enum CodingKeys: String, CodingKey {
                case title
                case body
                case titleLocKey = "title-loc-key"
                case titleLocArgs = "title-loc-args"
                case actionLocKey = "action-loc-key"
                case locKey = "loc-key"
                case locArgs = "loc-args"
                case launchImage = "launch-image"
            }
            
            let title: String?
            let body: String
            let titleLocKey: String?
            let titleLocArgs: [String]?
            let actionLocKey: String?
            let locKey: String?
            let locArgs: [String]?
            let launchImage: String?
        }
        
        enum CodingKeys: String, CodingKey {
            case alert
            case badge
            case sound
            case contentAvailable = "content-available"
            case mutableContent = "mutable-content"
            case category
            case threadId = "thread-id"
        }
        
        let alert: Alert
        let badge: Int?
        let sound: String?
        let contentAvailable: Int?
        let mutableContent: Int?
        let category: String?
        let threadId: String?
    }

    enum CodingKeys: CodingKey {
        case aps
        case custom
    }
    
    let aps: APS
    let custom: [String: Any]?
    
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        let data = try encoder.encode(aps)
        
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

        guard var mutableJson = json as? [AnyHashable: Any] else {
            fatalError("JSON Object couldn't be casted as [AnyHashable: Any]")
        }
        
        custom?.forEach { (arg: (key: String, value: Any)) in
            let (key, value) = arg
            mutableJson[key] = value
        }
        
        print("JSON! \(mutableJson)")
        
        return try JSONSerialization.data(withJSONObject: mutableJson, options: .prettyPrinted)
    }
}
