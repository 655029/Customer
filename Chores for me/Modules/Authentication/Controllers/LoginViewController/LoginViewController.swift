//
//  LoginViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit
import Designable
import Alamofire
import Toast_Swift
import NVActivityIndicatorView
import GoogleSignIn
import FBSDKLoginKit
import CoreLocation
import FirebaseAuth
import FBSDKCoreKit


class LoginViewController: BaseViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var googleLoginButton: DesignableButton!
    @IBOutlet weak var showAndHidePasswordButtoon: UIButton!
    @IBOutlet weak var facebookLoginButton: DesignableButton!
    
    
    // MARK: - Properties
    var iconClick: Bool = true
    let locationManager = CLLocationManager()
    var tokenForPresentedLogoutVc:[String: String?] = [:]
    var tokenFromSegue: String?
    var mainSocailKey: String?
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        navigationController?.navigationBar.tintColor = .white
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        else {
        
        }
        applyDesigns()
        googleSignIn()
        facebookLoginButton.addTarget(self, action: #selector(didTappedFacebookButton(_:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myToken"), object: nil, userInfo: tokenForPresentedLogoutVc as [AnyHashable : Any])
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @objc func didTappedFacebookButton(_ sender: DesignableButton) {
        self.getFacebookUserInfo()
        
    }
    
     private func getFacebookUserInfo() {
            let loginManager = LoginManager()
          //  self.showActivity()
                loginManager.logIn(permissions: ["email","public_profile"], from: self) { (result, err) in
                //    self.hideActivity()
                    if result?.isCancelled == false{
                    let request = GraphRequest(graphPath: "me", parameters:  ["fields": "id, email, name, first_name, last_name, picture.type(large)"], tokenString: AccessToken.current?.tokenString, version: .none, httpMethod: .get)
                  //  self.showActivity()
                    request.start { (response, result, err) in
                     //   self.hideActivity()
                        if err == nil{
                            let resultDict = result as? [String:Any] ?? [:]
                            print(resultDict)
                            self.mainSocailKey = resultDict["id"] as? String
                            RegisterViewController.userName = resultDict["name"] as? String
                            RegisterViewController.gmailName = resultDict["email"] as? String
                            UserStoreSingleton.shared.name = resultDict["first_name"] as? String
                            UserStoreSingleton.shared.lastname = resultDict["last_name"] as? String
                            let dataDict = resultDict["picture"] as? [String:Any] ?? [:]
                            let imageDict = dataDict["data"] as? [String:Any] ?? [:]
                            UserStoreSingleton.shared.socailProfileImage = imageDict["url"] as? String ?? ""
                            self.callingSocialSignInAPI()
                        }else{
                            self.showMessage(err?.localizedDescription ?? "")
                        }
                    }
                }
            }
        }
    
    
    
    // MARK: - Layout
    private func applyDesigns() {
        googleLoginButton.addSpaceBetweenImageAndTitle(spacing: 6.0)
        let imageView = UIImage(named: "square-with-round")?.withRenderingMode(.alwaysTemplate)
        showAndHidePasswordButtoon.setImage(imageView, for: .normal)
        let imageView2 = UIImage(named: "checkbox")?.withRenderingMode(.alwaysTemplate)
        showAndHidePasswordButtoon.setImage(imageView2, for: .selected)
        showAndHidePasswordButtoon.tintColor = .white
    }
    
    
    // MARK: - User Interaction
    @IBAction func loginButtonAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if email == ""{
                openAlert(title: "Alert", message: "Please Enter valid Email Id", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }
            else if !email.isValidEmail {
                openAlert(title: "Alert", message: "Please Enter valid Email Id", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
                
            }
            
            else if password == "" {
                openAlert(title: "Alert", message: "Please Enter Password", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }
            
            else {
                UserDefaults.standard.removeObject(forKey: "DialCode")
                self.userLogin()
                
            }
        }
        
        
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
        navigate(.forgotPassword)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        navigate(.register)
    }
    
    @IBAction func showAndHideButtonAction(_ sender: Any) {
        if (iconClick ==  true) {
            passwordTextField.isSecureTextEntry = false
        }
        else {
            passwordTextField.isSecureTextEntry = true
        }
        iconClick = !iconClick
        showAndHidePasswordButtoon.isSelected.toggle()
        
    }
    
    @IBAction func googleLoginButton(_ sender: DesignableButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    
    
    // MARK: - Additional Helpers
    func googleSignIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
}



// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case emailTextField:
                passwordTextField.becomeFirstResponder()
            case passwordTextField:
                break
            default:
                textField.resignFirstResponder()
        }
        
        return true
    }
    
    func userLogin() {
        self.showActivity()
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/login") else { return }
        print(gitUrl)
        let request = NSMutableURLRequest(url: gitUrl)
        let parameters = [
            "email" :emailTextField.text ?? "",
            "password": passwordTextField.text ?? "",
            "signupType":"0",
            "deviceID":UserStoreSingleton.shared.fcmToken ?? "",
            "deviceType":1,
        ] as [String : Any]
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else { return }
            do {
                let gitData = try JSONDecoder().decode(LoginModel.self, from: data)
                print("response data:", gitData)
                DispatchQueue.main.async {
                    self.hideActivity()
                    let phoneNumber = gitData.data?.phone
                    let headersvalue = gitData.data?.token
                    let responseMessage = gitData.status
                    if responseMessage == 200 {
                        self.hideActivity()
                        self.tokenForPresentedLogoutVc = ["token": headersvalue]
                        UserStoreSingleton.shared.Token = headersvalue
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myToken"), object: nil, userInfo: self.tokenForPresentedLogoutVc as [AnyHashable : Any])
                        self.tokenFromSegue = headersvalue
                        self.callingGetUserProfile()
                        UserStoreSingleton.shared.isLoggedIn = true
                        LogoutViewController.tokenForPresentedLogout = headersvalue
                        UserStoreSingleton.shared.email = self.emailTextField.text
                        UserStoreSingleton.shared.phoneNumber = phoneNumber
                        UserStoreSingleton.shared.userToken = gitData.data?.token
                        
                        
                        if gitData.data?.user_verified  == 0 {
                            self.navigate(.twosetpVerification)
                        }
                        
                        else {
                            RootRouter().loadMainHomeStructure()
                        }
                        
                    }
                    else{
                        self.showMessage(gitData.message ?? "")
                    }
                }
            } catch let err {
                print("Err", err)
                print("Not Logedin")
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVc = segue.destination as! LogoutViewController
        LogoutViewController.tokenForPresentedLogout = tokenFromSegue
    }
    
    func CheckLocationPermision() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    return false
                case .authorizedAlways, .authorizedWhenInUse:
                    return true
                default:
                    return false
            }
        } else {
            return false
        }
    }
    
    
    func callingGetUserProfile() {
        self.showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-user-Profile")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.hideActivity()
            do {
                let json =  try JSONDecoder().decode(SetUpProfile.self, from: data ?? Data())
                debugPrint(json)
                DispatchQueue.main.async {
                    UserStoreSingleton.shared.name = json.data?.first_name
                    let name = json.data?.name
                    if json.data?.first_name == nil {
                        let fullName = name
                        let fullNameArr = fullName?.components(separatedBy: " ")
                        let firstName = fullNameArr?[0]
                        let lastName = fullNameArr?[1]
                        UserStoreSingleton.shared.name = firstName
                    }
                    UserStoreSingleton.shared.userID = json.data?.userId
                    if json.data?.image != nil {
                        UserStoreSingleton.shared.profileImage = json.data?.image
                    }
                }
            } catch {
                print(error)
                self.hideActivity()
            }
        }
        task.resume()
    }
    
    
    func callingSocialSignInAPI() {
        self.showActivity()
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/social-signIn") else { return }
        print(gitUrl)
        var request = URLRequest(url: gitUrl)
        let parameters = ["socialKey" : mainSocailKey,"signUpType": "0"] as [String: Any]
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
            do {
                let gitData = try JSONDecoder().decode(SocailSignInModel.self, from: data)
                print("response data:", gitData)
                DispatchQueue.main.async {
                    self.hideActivity()
                    let responseMessage = gitData.status
                    if responseMessage == 200 {
                        let phoneNumber = gitData.data?.phone
                        let headersvalue = gitData.data?.token
                        UserStoreSingleton.shared.isLoggedIn = true
                        UserStoreSingleton.shared.Token = headersvalue
                        UserStoreSingleton.shared.email = self.emailTextField.text
                        UserStoreSingleton.shared.phoneNumber = phoneNumber
                        UserStoreSingleton.shared.userToken = gitData.data?.token
                        self.showMessage(gitData.message ?? "")
                        RootRouter().loadMainHomeStructure()
                    }
                    else{
                        self.showMessage(gitData.message ?? "")
                    }
                    
                }
            } catch let err {
                print("Err", err)
                print("Not Logedin")
            }
                
            }
        }.resume()
        
    }
    
}


extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        guard let gmailUserImageUrl = GIDSignIn.sharedInstance()?.currentUser.profile.imageURL(withDimension: 120)?.absoluteString else {return}
        if let error = error {
            print(error.localizedDescription)
            return
        }
        if let optionalCurrentUser = GIDSignIn.sharedInstance().currentUser {
            guard let socailKey = optionalCurrentUser.userID else {return}
            mainSocailKey = socailKey
            guard let gmailUsername = optionalCurrentUser.profile.name else {return}
            print(gmailUsername)
            print(optionalCurrentUser.profile.email)
            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            print(profilePicUrl)
            self.callingSocialSignInAPI()
        }
    }
    
}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["feilds": "id, name, first_name, last_name, picture.type(large), email"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (connection, result, error) in
            print("\(String(describing: result))")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
}
