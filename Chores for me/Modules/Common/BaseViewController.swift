//
//  BaseViewController.swift
//  Chores for me
//
//  Created by Chores for me 2021 on 14/04/21.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView

class BaseViewController: UIViewController {

    // MARK: - Outlets

    // MARK: - Properties

    override var navigationController: BaseNavigationController? {
        return super.navigationController as? BaseNavigationController
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Lifecycle

    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            CheckTimeFunc()
        } else {
            // Fallback on earlier versions
            CheckTimeFunc()
        }
        hideKeyboardWhenTappedAround()
    }

    // MARK: - Layout
    
    // MARK: - User Interaction


    // MARK: - Additional Helpers
    func showMessage(_ withMessage : String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.cornerRadius = 5.0
        style.backgroundColor = .black
        style.messageFont = UIFont.boldSystemFont(ofSize: 18.0)
        self.view.clearToastQueue()
        self.view.makeToast(withMessage, duration: 2.0, position: .top, style: style)
    }

    func showActivity() {
        let activityData = ActivityData(size: CGSize(width: 30, height: 30), type: .circleStrokeSpin, color: .white, backgroundColor: UIColor(named: "AppColor"))
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }

    func hideActivity() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }

    
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension UIViewController {
    func CheckTimeFunc(){
//        let componets = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
//        let currentHour = componets.hour
        let date = Date()
        let calendar = Calendar.current
        let timee = TimeZone.current.identifier
        print(timee)
        let currentHour = calendar.component(.hour, from: date)
        print("test currentHour\(String(currentHour ?? 0))")

  //      let currentMint = components.minute ?? 0
   //     print("test currentMint\(String(currentMint ?? 0))")
        print("test Time\(String(describing: currentHour))")
        if currentHour < 7 || currentHour > 21 {
            print ("show popup")
            self.TimePopupAlert()
        } else {
            print ("do nothing")
        }
    }

    @objc func TimePopupAlert(){
        let alertController = UIAlertController (title: "Chores for Me", message: "You can use this app only 7am to 10pm", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.exitApp()
        }))
        //alertController.addAction(firstAction)

        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)

    }

    func exitApp() {
           exit(0)
    }

}
