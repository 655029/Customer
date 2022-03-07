//
//  SplashViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @IBAction func continueButtonAction(_ sender: Any) {
//        let isLogin = UserStoreSingleton.shared.isLoggedIn
//        let authToken = UserStoreSingleton.shared.Token
//        if(isLogin!){
//            print("Token",""+authToken!)
//        }else{
//            print("Token","Null")
//
//        }
        navigate(.login)
    }
    
    // MARK: - Additional Helpers
    
}
