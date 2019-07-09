//
//  FacebookLoginManager.swift
//  RecipeFarm
//
//  Created by Fermata 강상우 on 17/06/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

public class FacebookManager: NSObject {
    
    public typealias loginHandler = (Any?, Error?) -> Void
    
    static var shared = FacebookManager()
    
    let manager = LoginManager()
    var token: AccessToken? {
        get {
            return AccessToken.current
        }
    }
    
    public func getEmail(_ viewController: UIViewController, handler: @escaping loginHandler) {
        login(viewController, handler: handler)
    }
    
    public func shareLink(_ url: String) {
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootVC = window.rootViewController else { return }
        guard let url = URL(string: url) else { return }
        let content = ShareLinkContent()
        content.contentURL = url
        let dialog = ShareDialog(fromViewController: rootVC, content: content, delegate: self)
        dialog.fromViewController = rootVC
        dialog.mode = .automatic
        dialog.show()
    }
    
    public func login(_ viewController: UIViewController, handler: @escaping loginHandler) {
        manager.logIn(permissions: ["public_profile", "email"], from: viewController) { (result, error) in
            
            let request = GraphRequest(graphPath: "/me", parameters: ["fields":"email"])
            request.start(completionHandler: { (connection, result, error) in
                handler(result, error)
            })
        }
    }
    
    public func logout() {
        manager.logOut()
    }
}


extension FacebookManager: SharingDelegate {
    public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print()
    }
    
    public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print()
    }
    
    public func sharerDidCancel(_ sharer: Sharing) {
        print()
    }
    
    
}
