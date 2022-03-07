//
//  RegisterViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit
import ADCountryPicker
import Alamofire
import GoogleSignIn
import Designable
import FBSDKLoginKit

struct ImageRequest: Encodable {
    let attchment: String
    let fileName: String
}


class RegisterViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ADCountryPickerDelegate {


    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: AppTextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNoTextFeild: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfeild: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var countryCodeTextFeild: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var googleLoginButton: DesignableButton!
    @IBOutlet weak var facebookLoginButton: DesignableButton!
    @IBOutlet weak var viewPasswordBtn: UIButton!
    @IBOutlet weak var viewConfirmPasswordBtn: UIButton!
    

    // MARK: - Properties
    static var socailKey: String?
    static var gmailName: String?
    static var userName: String?
    var imagePicker = UIImagePickerController()
    let picker = ADCountryPicker()
    var photoURL : URL!
    var imageResponse: String?
    var viewPasswordIcon: Bool = true
    var viewConfirmPasswordIcon: Bool = true


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        mobileNoTextFeild.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextfeild.delegate = self
        picker.delegate = self
        picker.showCallingCodes = true
        picker.showFlags = true
        picker.pickerTitle = "Select a Country"
        picker.defaultCountryCode = "US"
        picker.forceDefaultCountryCode = true
        self.googleSignIn()
        facebookLoginButton.addTarget(self, action: #selector(didtappedFacebookButton(_:)), for: .touchUpInside)
        picker.font = UIFont(name: "Helvetica Neue", size: 18)

    }


    // MARK: - User Interaction
    @objc func didtappedFacebookButton(_ sender: DesignableButton) {
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
                            RegisterViewController.socailKey = resultDict["id"] as? String
                            RegisterViewController.userName = resultDict["name"] as? String
                            RegisterViewController.gmailName = resultDict["email"] as? String
                            UserStoreSingleton.shared.name = resultDict["first_name"] as? String
                            UserStoreSingleton.shared.lastname = resultDict["last_name"] as? String
                            let dataDict = resultDict["picture"] as? [String:Any] ?? [:]
                            let imageDict = dataDict["data"] as? [String:Any] ?? [:]
                            UserStoreSingleton.shared.socailProfileImage = imageDict["url"] as? String ?? ""
                            self.navigate(.facebookSignUp)
                        }else{
                            self.showMessage(err?.localizedDescription ?? "")
                        }
                    }
                }
            }
        }
    
    
    @IBAction func registerButtonAction(_ sender: Any) {
        if let name = nameTextField.text, let email = emailTextField.text, let phoneNumber = mobileNoTextFeild.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextfeild.text, let imageSystem =  UIImage(named: "upload profile picture") {

            if profileImage.image?.pngData() == imageSystem.pngData() {
                openAlert(title: "Alert", message: "Please upload image.", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

            else  if name == "" {
                openAlert(title: "Alert", message: "Please Enter Name", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{_ in
                    print("Okay")
                }])

            }

            else if  email == "" {
                openAlert(title: "Alert", message: "Please Enter Email", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }
               else if !email.isValidEmail {
                    openAlert(title: "Alert", message: "Invalid Email Address", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                        print("Okay")
                    }])
                }


            else if phoneNumber == "" {
                openAlert(title: "Alert", message: "Please Enter Mobile Number", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])

            }

            else if !phoneNumber.isPhoneNumber {
                openAlert(title: "Alert", message: "Invalid Phone Number", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])

            }

            else if password == "" {
                openAlert(title: "Alert", message: "Please Enter Password", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

            else if !password.isPasswordValid {
                openAlert(title: "Alert", message: "Invalid Password!, Password must contain at least 7 characters, including UPPER/lowercase and numbers", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

            else if confirmPassword == "" {
                openAlert(title: "Alert", message: "Please Enter Confirm  Password", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])

            }

            else if confirmPassword != password{
                openAlert(title: "Alert", message: "Password and Confirm Password Are Not Equal ", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])

            }

            else {
                self.RegisterApi()
            }

        }

    }

    @IBAction func backToLoginButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)

    }

    @IBAction func didTappedTextFeild(_sender: UITapGestureRecognizer) {
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)

    }

    @IBAction func googleLoginButton(_ sender: DesignableButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func didTappedShowPasswordBtn(sender: UIButton) {
        viewPasswordBtn.isSelected.toggle()
        if(viewPasswordIcon == true) {
                    passwordTextField.isSecureTextEntry = false
                } else {
                    passwordTextField.isSecureTextEntry = true
                }

        viewPasswordIcon = !viewPasswordIcon
    }
    
    @IBAction func didTappedShowConfirmPasswordBtn(sender: UIButton) {
        viewConfirmPasswordBtn.isSelected.toggle()
        if(viewConfirmPasswordIcon == true) {
                    confirmPasswordTextfeild.isSecureTextEntry = false
                } else {
                    confirmPasswordTextfeild.isSecureTextEntry = true
                }

        viewConfirmPasswordIcon = !viewConfirmPasswordIcon
    }

    
    //MARK: - AdPickerCountryCode TextFeild
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        countryCodeTextFeild.text = dialCode
        picker.font = UIFont(name: "Medium", size: 22.0)
        UserStoreSingleton.shared.DialCode = dialCode
        self.dismiss(animated: true, completion: nil)

    }

    
    // MARK: - Additional Helpers
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }

    func googleSignIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }

    func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }

        switch src.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        }

        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        ctx.concatenate(transform)

        switch src.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }

        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)

        return img
    }}


// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
        case nameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            mobileNoTextFeild.becomeFirstResponder()
        case mobileNoTextFeild:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextfeild.becomeFirstResponder()
        case confirmPasswordTextfeild:
            // Register action
            break
        default:
            textField.resignFirstResponder()
        }

        return true
    }

    //MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImage = self.imageOrientation(selectedImage)
        profileImage.image = selectedImage

        if (picker.sourceType == .photoLibrary) {
            if let imgUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                let pickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                profileImage.image = pickerImage
                let imgName = imgUrl.lastPathComponent
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)

                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                let data = image.jpegData(compressionQuality: 0.3)! as NSData
                data.write(toFile: localPath, atomically: true)
                photoURL = URL.init(fileURLWithPath: localPath)
                print(photoURL!)
            }
        }
        else
        {
            let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            profileImage.image = pickedImage
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            let data = pickedImage!.jpegData(compressionQuality: 0.3)! as NSData
            data.write(toFile: localPath, atomically: true)
            photoURL = URL.init(fileURLWithPath: localPath)
            print(photoURL!)
            picker.dismiss(animated: true, completion: nil)
        }
        self.dismiss(animated: true, completion: nil)
        uploadImage(paramName: "photo", fileName: "png", image: selectedImage)
    }

}


//MARK: - GoogleSignIn Button Delegate
extension RegisterViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        if let optionalCurrentUser = GIDSignIn.sharedInstance()?.currentUser {
            guard let socialKey = optionalCurrentUser.userID else {return}
            RegisterViewController.socailKey = socialKey
            guard let gmailUserName = optionalCurrentUser.profile.name else {return}
            RegisterViewController.userName = gmailUserName
            guard let gmailUserEmail = optionalCurrentUser.profile.email else {return}
            RegisterViewController.gmailName = gmailUserEmail
        }
        self.navigate(.googleSignUp)
//        self.callingSocailSignUpAPI()
        
    }

}


//MARK: - Validations For Email & Password
extension String {
    var isPasswordValid: Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{7,}$")
        return passwordTest.evaluate(with: self)
    }

    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }

    var isPhoneNumber: Bool {
            do {
                let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
                let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
                if let res = matches.first {
                    return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
                } else {
                    return false
                }
            } catch {
                return false
            }
        }

}


//MARK: - API Manager
extension RegisterViewController {
   private func RegisterApi() {
        self.showActivity()
        let Url = String(format: "http://3.18.59.239:3000/api/v1/signup")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary =  ["email":emailTextField.text ?? "","image": imageResponse ?? "","first_name":nameTextField.text ?? "","last_name":lastNameTextField.text ?? "","password": passwordTextField.text ?? "","phone": "\(UserStoreSingleton.shared.DialCode ?? "")\(mobileNoTextFeild.text ?? "")" ,"signupType":"0","otp":"","location_address":""] as [String: Any]
        print(parameterDictionary)
        UserStoreSingleton.shared.name = nameTextField.text
        UserStoreSingleton.shared.lastname = lastNameTextField.text
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
                self.hideActivity()
            }
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(RegisterModel.self, from: data)
                    print(json)
                    DispatchQueue.main.async {
                        self.hideActivity()
                        let responseMessage = json.status;
                        if responseMessage == 200 {
                            UserStoreSingleton.shared.phoneNumber = self.mobileNoTextFeild.text
                            self.sendOtp()

                        }else{
                            self.hideActivity()
                            self.showMessage(json.message ?? "")
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

    private func sendOtp() {
        showActivity()
            guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/sendOtp") else { return }
            print(gitUrl)

            let request = NSMutableURLRequest(url: gitUrl)
        let phoneNumber = "\(UserStoreSingleton.shared.DialCode ?? "")\(UserStoreSingleton.shared.phoneNumber ?? "")"
        let parameters = ["phone": phoneNumber, "signupType": "0"]
            let session = URLSession.shared
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        session.dataTask(with: request as URLRequest) { [self] data, response, error in

                guard let data = data else { return }
                do {
                    let gitData = try JSONDecoder().decode(SendOtpModel.self, from: data)
                    print("response data:", gitData)
                    DispatchQueue.main.async {
                        hideActivity()
                        showMessage(gitData.message ?? "")
                        UserStoreSingleton.shared.OtpCode = gitData.data?.oTP
                        self.navigate(.twosetpVerification)
//                            verificationTextField.text = getOtp
                    }
                } catch let err {
                    print("Err", err)
                    print("Not Logedin")
                }
            }.resume()
    }

    private func callingSocailSignUpAPI() {
        self.showActivity()
        let url = URL(string: "http://3.18.59.239:3000/api/v1/social-signUp")
        let parameterDictionary = ["name": RegisterViewController.userName ?? "","email": "testing6068@gmail.com"/*RegisterViewController.gmailName ?? ""*/,"image":"","socialKey": RegisterViewController.socailKey ?? "","signupType":"0"] as [String: Any]
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
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
                    let json = try JSONDecoder().decode(GoogleSignUpModel.self, from: data)
                    print(json)
                    DispatchQueue.main.async {
                        self.hideActivity()
                        let responseMessage = json.status;
                        if responseMessage == 200 {
                            UserStoreSingleton.shared.Token = json.data?.token
                            self.showMessage(json.message ?? "")
                            self.navigate(.login)
                        }else{
                            self.showMessage(json.message ?? "")
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()

    }


    //MARK: -  Calling Upload image API
     private func uploadImage(paramName: String, fileName: String, image: UIImage) {
        let url = URL(string: "http://3.18.59.239:3000/api/v1/upload")
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        let session = URLSession.shared
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var data = Data()
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    if let imageData = json["data"] {
//                        UserStoreSingleton.shared.profileImage = imageData as! String
                        self.imageResponse = (imageData as! String)
                    }

                }
            }
        }).resume()
    }


}




