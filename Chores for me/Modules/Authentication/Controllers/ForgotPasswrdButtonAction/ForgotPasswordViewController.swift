//
//  ForgotPasswordViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit
import Alamofire
import Toast_Swift
import NVActivityIndicatorView

class ForgotPasswordViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak private var emailTextFeild: UITextField!
    @IBOutlet weak private var backButon: UIButton!

    // MARK: - Properties

    // MARK: - Lifecycle

    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem.title = AppString.FORGOT_PASSWORD
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .white
        emailTextFeild.layer.borderWidth = 0.5
        emailTextFeild.layer.borderColor = UIColor.lightGray.cgColor
        emailTextFeild.layer.cornerRadius = 5.0
        let image = UIImage(named: "BACK")?.withRenderingMode(.alwaysTemplate)
        backButon.setImage(image, for: .normal)
        backButon.tintColor = .white
        emailTextFeild.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: emailTextFeild.frame.height))
        emailTextFeild.leftViewMode = .always
//        forgotPasswordAPI()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Layout

    // MARK: - User Interaction

    @IBAction func sendButtonAction(_ sender: Any) {
        if let emailText = emailTextFeild.text {
            if emailText == "" {
                openAlert(title: "Alert", message: "Please Enter Email", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }
           else if !emailText.isValidEmail {
                openAlert(title: "Alert", message: "invalid Email Address", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }
           else {
            forgotPasswordAPI()
           }

        }
//       navigate(.forgotPasswordOTP)
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Additional Helpers


    func forgotPasswordAPI() {
        self.showActivity()
        let Url = String(format: "http://3.18.59.239:3000/api/v1/forgot-password")
        guard let serviceUrl = URL(string: Url) else { return }
        var urlRequest = URLRequest(url: serviceUrl)
        let parameterDictionary =  ["email": emailTextFeild.text ?? ""] as [String: Any]
        UserStoreSingleton.shared.email = emailTextFeild.text
        let session = URLSession.shared
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameterDictionary, options: [])

        session.dataTask(with: urlRequest as URLRequest) { data, response, error in

            guard let data = data else { return }
            do {

                let gitData = try JSONDecoder().decode(ForgotPasswordModel.self, from: data)
                print("response data:", gitData)
                DispatchQueue.main.async {
                    let responseMessage = gitData.status
                    if responseMessage == 200 {
                        self.hideActivity()
                        self.showMessage(gitData.message ?? "")
                        self.navigate(.forgotPasswordOTP)

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
