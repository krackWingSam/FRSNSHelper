//
//  ViewController.swift
//  FRSNSHelper
//
//  Created by exs-mobile 강상우 on 09/07/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func action_NaverLogin(_ sender: UIButton) {
        NaverLoginManager.shared.getEmail { (email) in
            print(email)
        }
    }
    
    @IBAction func action_KakaoLogin(_ sender: UIButton) {
        KakaoLoginManager.shared.getKakaoProfile { (me) in
            print(me as Any)
        }
    }
    
    @IBAction func action_FacebookLogin(_ sender: UIButton) {
        FacebookManager.shared.getEmail(self) { (response, error) in
            print(response as Any, error as Any)
        }
    }
    
    @IBAction func action_GoogleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.clientID = "80056900262-ttf9f72acb3n17q0skobe10ggtm6l0r1.apps.googleusercontent.com"
        GoogleLoginManager.shared.UIDelegate = self
        GoogleLoginManager.shared.getEmail { (email) in
            print(email as Any)
        }
    }
}

extension ViewController: GIDSignInUIDelegate {
    // MARK: - GIDSignInUIDelegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
