//
//  GoogleSignUpViewController.swift
//  Chores for me
//
//  Created by Ios Mac on 22/02/22.
//

import UIKit
import ADCountryPicker

class GoogleSignUpViewController: BaseViewController, ADCountryPickerDelegate {
    
    
    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var gmailUserName: UILabel!
    @IBOutlet weak private var mobileNumberLabel: UILabel!
    @IBOutlet weak private var mobileNumberTextFeild: UITextField!
    @IBOutlet weak private var checkBoxButton: UIButton!

    
    //MARK: - Properties
    private var picker = ADCountryPicker()

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyFinishingTouchesToUIElements()
    }
    
    
    //MARK: - Helpers
    private func applyFinishingTouchesToUIElements() {
        mobileNumberLabel.layer.cornerRadius = mobileNumberLabel.frame.width/2
        gmailUserName.text = RegisterViewController.userName
        picker.delegate = self
        picker.showCallingCodes = true
        picker.showFlags = true
        picker.pickerTitle = "Select a Country"
        picker.defaultCountryCode = "US"
        picker.forceDefaultCountryCode = true
        picker.font = UIFont(name: "Helvetica Neue", size: 18)
    }
    
    private func callingSignUpAPI() {
        self.showActivity()
        let url = URL(string: "http://3.18.59.239:3000/api/v1/social-signUp")
        let phoneNumber = "\(UserStoreSingleton.shared.DialCode ?? "")\(mobileNumberTextFeild.text ?? "")"
        UserStoreSingleton.shared.socailPhoneNumber = phoneNumber
        let parameterDictionary = ["name": gmailUserName.text ?? "","email": RegisterViewController.gmailName ?? "","image": UserStoreSingleton.shared.socailProfileImage ?? "","phone": phoneNumber,"socialKey": RegisterViewController.socailKey ?? "","signupType":"0"] as [String: Any]
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
//                            self.navigate(.login)
                            self.sendOtp()
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
    
    private func sendOtp() {
        showActivity()
            guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/sendOtp") else { return }
            print(gitUrl)
            let request = NSMutableURLRequest(url: gitUrl)
        let phoneNumber = "\(UserStoreSingleton.shared.DialCode ?? "")\(mobileNumberTextFeild.text ?? "")"
        UserStoreSingleton.shared.socailPhoneNumber = phoneNumber
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
    
    
    //MARK: - Ineterface Builder Actions
    @IBAction func didTappedSignUpButton(_ sender: UIButton) {
        if let name = gmailUserName.text, let mobile = mobileNumberTextFeild.text, let image =  UIImage(named: "Unchecked-Checkbox-256") {
            if name == "" {
                openAlert(title: "Alert", message: "Name can't be empty.", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

           else if mobile == "" {
                openAlert(title: "Alert", message: "Please Enter Mobile Number", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }
            
           else if checkBoxButton.imageView?.image?.pngData() == image.pngData() {
                openAlert(title: "Alert", message: "Please Select Chores For Me Terms and Conditions", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
           }
            else {
                UserStoreSingleton.shared.phoneNumber = mobileNumberTextFeild.text
                self.callingSignUpAPI()
            }
        }
        
    }

    @IBAction func didTappedSignInButton(_ sender: UIButton) {
        navigate(.login)
    }
    
    @IBAction func didTappedCheckBoxButton(_ sender: UIButton) {
        checkBoxButton.isSelected.toggle()
    }
    
    @IBAction func didTappedShowCountriesButton(_ sender: UIButton) {
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        mobileNumberLabel.text = dialCode
        UserStoreSingleton.shared.DialCode = dialCode
        picker.font = UIFont(name: "Medium", size: 22.0)
        self.dismiss(animated: true, completion: nil)
    }
    
}
