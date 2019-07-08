//
//  FacebookLoginManager.swift
//  RecipeFarm
//
//  Created by exs-mobile 강상우 on 17/06/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class FacebookLoginManager: NSObject {
    
    typealias loginHandler = (Any?, Error?) -> Void
    
    static var shared = FacebookLoginManager()
    
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
    
    
    private func login(_ viewController: UIViewController, handler: @escaping loginHandler) {
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


extension FacebookLoginManager: SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print()
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print()
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        print()
    }
    
    
}
