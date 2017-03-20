import Foundation
import UIKit
import APNsKit

public class PushViewController: UIViewController {
    
    let pushButton = UIButton(type: .system)
    
    let connection: Connection
    let request: APNsRequest
    
    public init?(p12FileName: String, passPhrase: String, request: APNsRequest) {
        do {
            let connection = try Connection(p12FileName: p12FileName, passPhrase: passPhrase)
            self.connection = connection
            self.request = request
            super.init(nibName: nil, bundle: nil)
        } catch {
            print("Failed to create connection: \(error)")
            return nil
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.white
        
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        pushButton.setTitle( "⚡️Push⚡️", for: .normal)
        pushButton.titleLabel?.font = UIFont.systemFont(ofSize: 30.0)
        pushButton.sizeToFit()
        pushButton.translatesAutoresizingMaskIntoConstraints = false
        pushButton.addTarget(self, action: #selector(pushed), for: .touchUpInside)
        view.addSubview(pushButton)
        
        pushButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pushButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func pushed() {
        connection.send(request: request) {
            switch $0 {
            case .success:
                print("Succeeded!")
            case .failure(let errorCode, let message):
                print("Failed to push! \(errorCode), \(message)")
            }
        }
    }
}
