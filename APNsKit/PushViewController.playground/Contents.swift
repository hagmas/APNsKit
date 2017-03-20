import UIKit
import APNsKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

let request = APNsRequest(port: <#port#>,
                          server: <#server#>,
                          deviceToken: <#deviceToken#>,
                          payload: <#payload#>)

let pushVC: PushViewController
if let _pushVC = PushViewController(p12FileName: <#p12FileName#>,
                                    passPhrase: <#passPhrase#>,
                                    request: request) {
    pushVC = _pushVC
    pushVC.view.frame = CGRect(x: 0, y: 0, width: 414, height: 736)
    PlaygroundPage.current.liveView = pushVC
}
