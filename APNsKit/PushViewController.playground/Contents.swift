/*:

 # How to use this playground
 
 1. Build the framework with the target "Generic iOS Device".
 2. Create the provider client certificate. (Follow the steps described [here](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AddingCapabilities/AddingCapabilities.html#//apple_ref/doc/uid/TP40012582-CH26-SW11))
 3. Export your identity from the keychain app in the Personal Information Exchange Format (.p12) and place it under the Resources folder of this playground.
 4. Fill port number, developement/production server, the device token of the target device, the name of the p12 file and its pass phrase.
 5. You will see a view on the playground timeline and push the button to send notifications.
 */
 
import UIKit
import APNsKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

let payload = APNsPayload(body: "Hello, World!")
let request = APNsRequest(port: <#port#>,
                          server: <#server#>,
                          deviceToken: <#deviceToken#>,
                          payload: payload)

let pushVC: PushViewController
if let _pushVC = PushViewController(p12FileName: <#p12FileName#>,
                                    passPhrase: <#passPhrase#>,
                                    request: request) {
    pushVC = _pushVC
    pushVC.view.frame = CGRect(x: 0, y: 0, width: 414, height: 736)
    PlaygroundPage.current.liveView = pushVC
}
