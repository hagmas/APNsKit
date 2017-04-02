# APNsKit
A framework to send Apple notifications from Playground.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## About APNsKit
APNsKit is a swift framework to send Apple notifications to iOS devices. Especially, with Playground it lets you to create interactive tool to send push notifications for debugging purpose. Check out the Playground bundled with the Workspace. 

## Usage
```swift
import APNsKit

// Create a APNs payload. See Apple's Payload Key Reference (#1) for its specifications.
let payload = APNsPayload(title: "Hello World!", body: "This is APNsKit.", contentAvailable: 1)
let request = APNsRequest(port: .p2197,
                          server: .development,
                          deviceToken: "<#The target device token#>",
                          payload: payload)

// Create a connection that wraps up URLSession and its authentication challenges.
if let connection = try? Connection(p12FileName: "<#Your p12 file name#>", passPhrase: "<#The pass phrase for the file#>") {
    
    // Send the request to the APNs server. The connection has to be retained until the server responses.
    connection.send(request: request, resultHandler: { result in
        switch result {
        case .success:
            print("Succeeded!")
        case .failure(let code, let message):
            print("Failed to send: \(code), \(message)")
        }
    })
}
```
#1 [Apple's Payload Key Reference](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/PayloadKeyReference.html#//apple_ref/doc/uid/TP40008194-CH17-SW1)

