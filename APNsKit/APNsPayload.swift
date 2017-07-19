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
    
    public init(
        title: String? = nil,
        body: String,
        titleLocKey: String? = nil,
        titleLocArgs: [String]? = nil,
        actionLocKey: String? = nil,
        locKey: String? = nil,
        locArgs: [String]? = nil,
        launchImage: String? = nil,
        
        badge: Int? = nil,
        sound: String? = nil,
        contentAvailable: Int? = nil,
        mutableContent: Int? = nil,
        category: String? = nil,
        threadId: String? = nil,
        
        custom: [String: Any]? = nil) {
        
        let alert = APS.Alert(title: title,
                              body: body,
                              titleLocKey: titleLocKey,
                              titleLocArgs: titleLocArgs,
                              actionLocKey: actionLocKey,
                              locKey: locKey,
                              locArgs: locArgs,
                              launchImage: launchImage)
        
        let aps = APS(alert: alert,
                      badge: badge,
                      sound: sound,
                      contentAvailable: contentAvailable,
                      mutableContent: mutableContent,
                      category: category,
                      threadId: threadId)
        
        self.aps = aps
        self.custom = custom
    }

    internal func encode() throws -> Data {
        let encoder = JSONEncoder()
        let data = try encoder.encode(aps)
        
        let apsJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

        var json: [String: Any] = ["aps": apsJSON]
        
        custom?.forEach { (arg: (key: String, value: Any)) in
            let (key, value) = arg
            json[key] = value
        }
        
        return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    }
}
