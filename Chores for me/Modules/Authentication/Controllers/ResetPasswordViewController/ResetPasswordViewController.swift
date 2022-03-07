//
//  ResetPasswordViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView


class ResetPasswordViewController: BaseViewController {


    // MARK: - Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!


    // MARK: - Properties


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "BACK")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = .white
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    

    // MARK: - User Interaction
    @IBAction func resetPasswordButtonAction(_ sender: Any) {
        if let password = passwordTextField.text, let confirmPasswod = confirmPasswordTextField.text {
            if password == "" {
                openAlert(title: "Alert", message: "Please Enter Password", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }
            else if !password.isPasswordValid {
                openAlert(title: "Alert", message: "Invalid Password!, Password must contain at least 7 chacrters, including UPPER/lowercase and numbers", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

            else if confirmPasswod == "" {
                openAlert(title: "Alert", message: "Please Enter Confirm Password", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

            else if password != confirmPasswod {
                openAlert(title: "Alert", message: "Password and Confirm Password doesn't match", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }
            else {
                self.resetPasswordAPI()
            }

    }

    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }


    // MARK: - Additional Helpers
    func resetPasswordAPI() {
            self.showActivity()
            guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/reset-password") else { return }
            print(gitUrl)

            let request = NSMutableURLRequest(url: gitUrl)
        let parameters = ["email" :UserStoreSingleton.shared.email ?? "",
                              "password": passwordTextField.text ?? "",
                              "newPassword":confirmPasswordTextField.text ?? ""]
            let session = URLSession.shared
            request.httpMethod = "POST"
        request.setValue(UserStoreSingleton.shared.Token ?? "" , forHTTPHeaderField: "authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

            session.dataTask(with: request as URLRequest) { data, response, error in

                guard let data = data else { return }
                do {

                    let gitData = try JSONDecoder().decode(ResetPasswordModel.self, from: data)
                    print("response data:", gitData)
                    DispatchQueue.main.async {
                        self.hideActivity()
                        let responseMessage = gitData.status
                        if responseMessage == 200 {
                            self.showMessage(gitData.message ?? "Password Changed Successfully")
                            let isLoggin = UserStoreSingleton.shared.isLoggedIn
                            if isLoggin == true {
                                self.navigate(.EditButtonTapped)
                            }
                            else {
                                self.navigate(.login)
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

    
}


// MARK: - UITextFieldDelegate

extension ResetPasswordViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            break
        default:
            textField.resignFirstResponder()
        }

        return true
    }
}
