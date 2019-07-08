//
//  KakaoLoginManager.swift
//  RecipeFarm
//
//  Created by exs-mobile 강상우 on 19/06/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import KakaoLink
import KakaoMessageTemplate

class KakaoLoginManager: NSObject {
    
    typealias kakaoEmailHandler = (String) -> Void
    
    static let shared = KakaoLoginManager()
    
    private var session: KOSession!
    
    public var handler: kakaoEmailHandler?
    public var code: String?
    
    override init() {
        super.init()
        
        
        session = KOSession.shared()
        print(session as Any)
    }
    
    public func getEmail(_ handler: @escaping kakaoEmailHandler) {
        self.handler = handler
        login()
    }
    
    public func shareContent(_ title: String, url: String) {
        guard let url = URL(string: url) else { return }
        KLKTalkLinkCenter.shared().sendScrap(with: url, success: { (warnings, arguments) in
            print(warnings, arguments)
        }) { (error) in
            print(error)
        }
    }
    
    public func shareContentInStory(_ title: String, url: String) {
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        var urlString = "storylink://posting?"
        urlString += "post=\(url)&"
        urlString += "appid=\(bundleID)&"
        urlString += "appver=\(appVersion)&"
        urlString += "apiver=1.0&"
        urlString += "appname=RecipeFarm"
        
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func login() {
        if session.isOpen() {
            session.close()
        }
        
        session.open(completionHandler: handler_Login(error:))
    }
    
    public func logout() {
        session.close()
    }
    
    public func application(_ app: UIApplication, open: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let returnValue = KOSession.handleOpen(open)
        return returnValue
    }
    
    private func handler_Login(error: Error!) -> Void {
        if !self.session.isOpen() {
            if let error = error as NSError? {
                switch error.code {
                case Int(KOErrorCancelled.rawValue):
                    print(error.code)
                    break
                default:
                    //TODO: show Error
                    print(error.description)
                    break
                }
            }
        }
        else {
            getProfile()
        }
    }
    
    
    private func getProfile() {
        KOSessionTask.userMeTask { (error, me) in
            guard let me = me else { return }
            if me.account?.email == nil || me.account?.email == "" {
                // TODO: do something when email doesn't exist
            }
            else {
                print(me.account?.email! as Any)
                guard let email = me.account?.email else { return }
                if self.handler != nil {
                    self.handler!(email)
                    self.handler = nil
                }
            }
        }
    }
}
