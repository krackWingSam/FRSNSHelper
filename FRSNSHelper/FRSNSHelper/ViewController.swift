//
//  ViewController.swift
//  FRSNSHelper
//
//  Created by exs-mobile 강상우 on 09/07/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func action_NaverLogin(_ sender: UIButton) {
        
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
        GoogleLoginManager.shared.getEmail { (email) in
            print(email as Any)
        }
    }
}

