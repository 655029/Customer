//
//  SceneDelegate.swift
//  Chores for me
//
//  Created by Chores for me 2021 on 14/04/21.
//

import UIKit


@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    lazy private var router = RootRouter()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        //router.loadMainAppStructure()
        let isLogin = UserStoreSingleton.shared.isLoggedIn
        if(isLogin ?? false){
            RootRouter().loadMainHomeStructure()
        }else{
            let viewController = BaseNavigationController(rootViewController: Storyboard.Authentication.viewController(for: LoginViewController.self))
            viewController.view.layoutIfNeeded()
            window?.rootViewController = viewController
            print("Token","Null")
            }
          CheckTimeFunc()
//        UIView.animate(withDuration: 0.1,
//                       delay: 2.0,
//                       options: UIView.AnimationOptions.curveEaseIn,
//                   animations: { () -> Void in
//
//            let alert = UIAlertController(title: "Chores for Me", message: "You can use this app only 7am to 10pm", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
//                self.exitApp()
//            }))
//            DispatchQueue.main.async {
//            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
//            }
//        }, completion: { (finished) -> Void in
//        })
    }

    func CheckTimeFunc(){
        let componets = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        let currentHour = componets.hour
        if currentHour! < 7 || currentHour! > 21 {
            print ("show popup")
            self.TimePopupAlert()
        } else {
            print ("do nothing")

        }
    }
    
    @objc func TimePopupAlert(){
        UIView.animate(withDuration: 0.1,
                       delay: 2.0,
                       options: UIView.AnimationOptions.curveEaseIn,
                   animations: { () -> Void in

            let alert = UIAlertController(title: "Curfew Notice", message: "You can use this app only 7am to 10pm", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                self.exitApp()
            }))
            DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }, completion: { (finished) -> Void in
        })

    }

    func exitApp() {
           exit(0)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

}

