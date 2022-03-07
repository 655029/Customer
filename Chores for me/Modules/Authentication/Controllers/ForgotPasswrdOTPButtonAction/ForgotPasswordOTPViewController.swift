//
//  ForgotPasswordOTPViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit

class ForgotPasswordOTPViewController: BaseViewController, UITextFieldDelegate {


    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var firstOtpTextFeild: UITextField!
    @IBOutlet weak var secondOtpTextfeild: UITextField!
    @IBOutlet weak var thirdOtpTextfeild: UITextField!
    @IBOutlet weak var fourthOtpTextFeild: UITextField!
    @IBOutlet weak var otpCountLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!


    // MARK: - Properties
    var otpFeild: Int?
    var otpTimer = Timer()
    var totalTime = 31


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .white
        let image = UIImage(named: "BACK")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = .white
        firstOtpTextFeild.delegate = self
        secondOtpTextfeild.delegate = self
        thirdOtpTextfeild.delegate = self
        fourthOtpTextFeild.delegate = self
        resendButton.setTitle("Click in ", for: .normal)
        otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        firstOtpTextFeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        secondOtpTextfeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        thirdOtpTextfeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        fourthOtpTextFeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }


    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if (text?.utf16.count)! >= 1{
            switch textField{
            case firstOtpTextFeild:
                secondOtpTextfeild.becomeFirstResponder()
            case secondOtpTextfeild:
                thirdOtpTextfeild.becomeFirstResponder()
            case thirdOtpTextfeild:
                fourthOtpTextFeild.becomeFirstResponder()
            case fourthOtpTextFeild:
                fourthOtpTextFeild.resignFirstResponder()
            default:
                break
            }
        }else{
        }
        if  text?.count == 0 {
                    switch textField{
                    case firstOtpTextFeild:
                        firstOtpTextFeild.becomeFirstResponder()
                    case secondOtpTextfeild:
                        firstOtpTextFeild.becomeFirstResponder()
                    case thirdOtpTextfeild:
                        secondOtpTextfeild.becomeFirstResponder()
                    case fourthOtpTextFeild:
                        thirdOtpTextfeild.becomeFirstResponder()
                    default:
                        break
                    }
                }
                else{

                }
    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    // MARK: - User Interaction
    @IBAction func resendOtpButtonAction(_ sender: UIButton) {
        otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        otpCountLabel.isHidden = false
        resendButton.setTitle("Click in", for: .normal)
        totalTime = 31
        self.callingForgotPasswordAPI()
    }

    @objc func updateTimer() {
        if(totalTime > 0) {
                totalTime = totalTime - 1
                print(totalTime)
                otpCountLabel.text = String(totalTime)
            resendButton.setTitle("Click in", for: .normal)
            resendButton.isEnabled = false
        }
        else {
            otpCountLabel.isHidden = true
            resendButton.setTitle("Click Here", for: .normal)
            resendButton.isEnabled = true
            otpTimer.invalidate()
        }

    }

    @IBAction func verifyButtonAction(_ sender: Any) {
        if let firstTextFeildText = firstOtpTextFeild.text, let secondTextFeildText = secondOtpTextfeild.text, let thirdTextFeildText = thirdOtpTextfeild.text, let fourthTextFeildText = fourthOtpTextFeild.text {

            if firstTextFeildText == "" {
                openAlert(title: "Alert", message: "Please Enter OTP", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

            else if secondTextFeildText == "" {
                openAlert(title: "Alert", message: "otp doesn't match", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

            else if thirdTextFeildText == "" {
                openAlert(title: "Alert", message: "otp doesn't match", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

            else if fourthTextFeildText == "" {
                openAlert(title: "Alert", message: "otp doesn't match", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }
            else {
                self.callingVerifyOtpAPI()
            }
        }
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)

    }

    // MARK: - Additional Helpers
    func callingVerifyOtpAPI() {
        self.showActivity()
            let Url = String(format: "http://3.18.59.239:3000/api/v1/reset-otp-verification")
                guard let serviceUrl = URL(string: Url) else { return }
        let email = UserStoreSingleton.shared.email
        let otp = "\(firstOtpTextFeild.text ?? "")\(secondOtpTextfeild.text ?? "")\(thirdOtpTextfeild.text ?? "")\(fourthOtpTextFeild.text ?? "")"

        let parameterDictionary =  ["email": email ?? "" ,"OTP": otp] as [String: Any]

                var request = URLRequest(url: serviceUrl)
                request.httpMethod = "POST"
                request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                    return
                }
                request.httpBody = httpBody
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    guard let data = data else { return }
                    do {
                        self.hideActivity()
                        let gitData = try JSONDecoder().decode(VerifyOtpWithEmailModel.self, from: data)
                        print("response data:", gitData)
                        DispatchQueue.main.async {
                            if gitData.status == 200 {
                                let token = gitData.data?.token
                                UserStoreSingleton.shared.userToken = token
                                self.showMessage(gitData.message ?? "")
                                self.navigate(.resetPassword)
                            }
                            else {
                                self.hideActivity()
                                self.showMessage(gitData.message ?? "")
                                self.hideActivity()
                            }
                        }
                    } catch let err {
                        print("Err", err)
                        print("Not Logedin")
                    }
                }.resume()
    }
    
    private func callingForgotPasswordAPI() {
        self.showActivity()
        let Url = String(format: "http://3.18.59.239:3000/api/v1/forgot-password")
        guard let serviceUrl = URL(string: Url) else { return }
        var urlRequest = URLRequest(url: serviceUrl)
        let parameterDictionary =  ["email": UserStoreSingleton.shared.email ?? ""] as [String: Any]
        let session = URLSession.shared
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameterDictionary, options: [])

        session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            self.hideActivity()
            guard let data = data else { return }
            do {

                let gitData = try JSONDecoder().decode(ForgotPasswordModel.self, from: data)
                print("response data:", gitData)
                DispatchQueue.main.async {
                    let responseMessage = gitData.status
                    if responseMessage == 200 {
                        self.hideActivity()
                        self.showMessage(gitData.message ?? "")
                    }
                    else{
                        self.hideActivity()
                        self.showMessage(gitData.message ?? "")
                    }

                }
            } catch let err {
                print("Err", err)
                print("Not Logedin")
            }
        }.resume()
    }
}
