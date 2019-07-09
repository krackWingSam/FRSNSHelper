//
//  GoogleLoginManager.swift
//  RecipeFarm
//
//  Created by Fermata 강상우 on 17/06/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleLoginManager: NSObject, GIDSignInDelegate {

    typealias googleEmailHandler = (String) -> Void
    typealias googleTokenHandler = (String) -> Void
    
    static var shared = GoogleLoginManager()
    
    var emailHandler: googleEmailHandler?
    var tokenHandler: googleTokenHandler?
    var manager = GIDSignIn.sharedInstance()!
    var UIDelegate: GIDSignInUIDelegate? {
        get {
            return manager.uiDelegate
        }
        set {
            manager.uiDelegate = newValue
        }
    }
    
    override init() {
        super.init()
        
        manager.clientID = "430592542405-vjmuku3toprivt52spqdv3t5j1i0vak9.apps.googleusercontent.com"
        manager.delegate = self
    }
    
    public func getEmail(_ handler: @escaping googleEmailHandler ) {
        self.emailHandler = handler
        login()
    }
    
    public func getToken(_ handler: @escaping googleTokenHandler) {
        tokenHandler = handler
        login()
    }
    
    private func login() {
        manager.scopes = ["https://www.googleapis.com/auth/youtube"]
//        EXLoadingViewController.shared.show()
        manager.signIn()
    }
    
    public func logout() {
        manager.signOut()
    }
    
    
    // MAKR: GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        EXLoadingViewController.shared.hide()
        if error != nil {
            print("error : \(error.debugDescription)")
        }
        else {
            if user?.authentication.accessToken != nil && self.tokenHandler != nil {
                self.tokenHandler!(user!.authentication.accessToken)
                self.tokenHandler = nil
            }
            
            guard let email = user?.profile.email else { return }
            if self.emailHandler != nil {
                self.emailHandler!(email)
                self.emailHandler = nil
            }
        }
    }
}
