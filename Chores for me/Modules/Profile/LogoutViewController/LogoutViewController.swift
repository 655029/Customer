//
//  LogoutViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 24/04/21.
//

import UIKit
import Foundation
import Alamofire

protocol DissmissLogoutViewController: class {
    func didTappedLogoutButton(controller: LogoutViewController)
}

class LogoutViewController: UIViewController {


    //MARK: - Properties
    weak var delegate: DissmissLogoutViewController?
    static var tokenForPresentedLogout: String?


    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        self.setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(getToken(n:)), name: NSNotification.Name(rawValue: "myToken"), object: nil)
        print(LogoutViewController.tokenForPresentedLogout as Any)

    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.setHidesBackButton(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(getToken(n:)), name: NSNotification.Name(rawValue: "myToken"), object: nil)


        NotificationCenter.default.addObserver(self, selector: #selector(self.getToken(n:)), name: Notification.Name("myToken"), object: nil)

    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }



    //MARK: - Interface Builder Actions
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func logoutButtonAction(_ sender: UIButton) {
        self.callingLogoutAPI()

    }

    @objc func getToken(n: NSNotification) {
        print(n)
        if let getToken = n.userInfo?["token"] {
            LogoutViewController.tokenForPresentedLogout  = getToken as? String
            print(getToken)
        }
        }

    @objc func popupAlert(){
           let alert = UIAlertController(title: "Chores for Me",
                                         message: "Are you sure you want to logout?",
                                         preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.callingLogoutAPI()
                   }))
           alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                   }))
           alert.view.tintColor = UIColor.black
           self.navigationController?.present(alert, animated: true, completion: nil)
           }

    //MARK: - Additional Helpers
    lazy var blurredView: UIView = {
            // 1. create container view
            let containerView = UIView()
            // 2. create custom blur view
            let blurEffect = UIBlurEffect(style: .light)
            let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
            customBlurEffectView.frame = self.view.bounds
            // 3. create semi-transparent black view
            let dimmedView = UIView()
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            dimmedView.frame = self.view.bounds

            // 4. add both as subviews
            containerView.addSubview(customBlurEffectView)
            containerView.addSubview(dimmedView)
            return containerView
        }()

    func setupView() {
            // 6. add blur view and send it to back
            view.addSubview(blurredView)
            view.sendSubviewToBack(blurredView)
        }

    func callingLogoutAPI() {
                var url:String!
                url = "http://3.18.59.239:3000/api/v1/logout"
        UserStoreSingleton.shared.Token = LogoutViewController.tokenForPresentedLogout
        print("UserStoreSingleton.shared.Token ?? \(UserStoreSingleton.shared.Token ?? "")")
                let headers: HTTPHeaders = ["Authorization": UserStoreSingleton.shared.Token ?? ""]
                Alamofire.request(url, method: .get,encoding: JSONEncoding.default, headers: headers)
                    .responseJSON { response in
                        switch response.result{
                            case .success(let json):
                                print("logout response-----\(json)")
                                DispatchQueue.main.async {
                                   print(json)
                              //      UserDefaults.standard.removeObject(forKey: "Token")
                                    UserStoreSingleton.shared.isLoggedIn = false
                                    self.logout()
                                }
                            case .failure(let error):
                                print(error)
                            }
                    }

    }

    @objc func logout(){
    guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return}
        UserDefaults.standard.removeObject(forKey: "Token")
        //window.rootViewController = Storyboard.Authentication.viewController(for: LoginViewController.self)

        delegate?.didTappedLogoutButton(controller: self)

        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        if #available(iOS 13.0, *) {
            let rootVC = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(rootVC, animated: true)
//            let rootNC = UINavigationController(rootViewController: rootVC)
//            window.rootViewController = rootNC
//            window.makeKeyAndVisible()
        } else {
            let rootVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(rootVC, animated: true)
//            let rootNC = UINavigationController(rootViewController: rootVC)
//            window.rootViewController = rootNC
//            window.makeKeyAndVisible()
        }
            //window.makeKeyAndVisible()
    }
}
