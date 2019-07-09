//
//  NaverLoginManager.swift
//  RecipeFarm
//
//  Created by Fermata 강상우 on 17/06/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin

class NaverLoginManager: NSObject, NaverThirdPartyLoginConnectionDelegate {
    typealias emailResponseHandler = (String) -> Void
    static var shared = NaverLoginManager()
    
    let manager = NaverThirdPartyLoginConnection.getSharedInstance()
    var email: String?
    
    var callback_Email: emailResponseHandler?
    
    private override init() {
        super.init()
        
        manager?.delegate = self
        
        manager?.serviceUrlScheme = "com.Fermata.FRSNSHelper"
        manager?.consumerKey = "Ndg1IpIK6MEDTx2zwUrU"
        manager?.consumerSecret = "ocDbL8wcGh"
        manager?.appName = "FRSNSTest"
    }
    
    public func getEmail(_ callback: @escaping emailResponseHandler) {
        if isValidToken() {     // 토큰이 있는 경우
            if email != nil {       // 유저 정보가 있는 경우
                callback(email!)
            }
            else {                  // 유저 정보가 없는 경우
                callback_Email = callback
                getUserInfo()
            }
        }
        else {                  // 토큰이 없는 경우
            callback_Email = callback
            login()
        }
    }
    
    private func getUserInfo() {
        if isValidToken() == false {
            login()
        }
        else if isValidToken() {
            // TODO: Network API Communication needed
//            EXNetworkFunc.naver_GetEmail(manager!.accessToken) { (response) in
//                guard let data = response.data                                  else { return }
//                guard let message = data["message"] as? String                  else { return }
//                if message != "success"                                              { return } // get user info fail
//                guard let userData = data["response"] as? [AnyHashable: Any]    else { return }
//                guard let email = userData["email"] as? String                  else { return }
//
//                self.email = email
//
//                if self.callback_Email != nil {
//                    self.callback_Email!(email)
//                }
//            }
        }
    }
    
    public func shareContentInBend(_ title: String, _ url: String) {
        guard let appURL = URL(string: "bandapp://") else { return }
        if UIApplication.shared.canOpenURL(appURL) {
            guard let storeURL = URL(string: "itms-apps://itunes.apple.com/app/id542613198") else { return }
            UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
            return
        }
        
        let content = url
        let urlString = "bandapp://create/post?text=\(content)"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    public func login() {
        manager?.requestThirdPartyLogin()
    }
    
    public func logout() {
        manager?.requestDeleteToken()
    }
    
    public func receivedURL(_ url: URL!) {
        manager?.receiveAccessToken(url)
    }
    
    public func application(_ app: UIApplication, open: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return (manager?.application(app, open: open, options: options))!
    }
    
    private func isValidToken() -> Bool {
        let expireDate = manager?.accessTokenExpireDate
        if expireDate == nil { return false }
        
        if expireDate!.timeIntervalSinceNow > 0 as TimeInterval {
            return true
        }
        
        return false
    }
    
    
    // MARK: NaverThirdPartyLoginConnectionDelegate
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        print("oauth20ConnectionDidOpenInAppBrowser")
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        // received access token
        print("OAuth Success!\n\nAccess Token - \(manager!.accessToken.debugDescription)\n\nAccess Token Expire Date- \(manager!.accessTokenExpireDate.debugDescription)\n\nRefresh Token - \(manager!.refreshToken.debugDescription)")
        // 토큰 발급 이후에 자동으로 유저 정보를 갱신한다.
        getUserInfo()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("Refresh Success!\n\nAccess Token - \(manager!.accessToken.debugDescription)\n\nAccess sToken ExpireDate- \(manager!.accessTokenExpireDate.debugDescription)")
        // 토큰 발급 이후에 자동으로 유저 정보를 갱신한다.
        getUserInfo()
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("delete token success")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error.debugDescription)
    }
    
}
