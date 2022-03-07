//
//  PaymentModeViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 19/07/21.
//

import UIKit
import Stripe
import StripeCore

struct Images {
    var imageName: String
}

protocol DissmissConfirmAlertViewontroller: class {
    func didTapConttinueButton(controller: PaymentModeViewController)
}

class PaymentModeViewController: BaseViewController, STPPaymentCardTextFieldDelegate,UITextFieldDelegate {


    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var collectionViewTextFeild: UICollectionView!
    @IBOutlet weak private var cardHolderNameTextFeild: UITextField!
    @IBOutlet weak private var cardNumberTextFeild: UITextField!
    @IBOutlet weak private var expiryDateTextFeild: UITextField!
    @IBOutlet weak var monthExpiryTectField: UITextField!
    @IBOutlet weak private var CVVTextFeild: UITextField!
    @IBOutlet weak private var continueButton: UIButton!
    @IBOutlet weak private var backBarButton: UIButton!
    @IBOutlet weak private var backButton: UIButton!
    @IBOutlet weak var cardno: UITextField!
    @IBOutlet weak var cardViews: STPPaymentCardTextField!
    

    //MARK: -Properties
    private var imageData: [Images] = []
    let paymentTextField = STPPaymentCardTextField()
    var stripeToken: String?
    var paymentStatus: String?
    var TransactionStatus: String?
    var jobid: Int?
    var myJobDetails: JobDetailsdata!
    var delegate: DissmissConfirmAlertViewontroller?


    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        paymentTextField.postalCodeEntryEnabled = false
        imageData.append(Images.init(imageName: "card"))
        navigationController?.navigationItem.title = "Payment mode"
        navigationController?.navigationBar.tintColor = .white
        tabBarController?.tabBar.isHidden = false
        }


    func modifyCreditCardString(creditCardString : String) -> String {
         let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()

         let arrOfCharacters = Array(trimmedString)
         var modifiedCreditCardString = ""

         if(arrOfCharacters.count > 0) {
             for i in 0...arrOfCharacters.count-1 {
                 modifiedCreditCardString.append(arrOfCharacters[i])
                 if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                     modifiedCreditCardString.append(" ")
                 }
             }
         }
         return modifiedCreditCardString
     }

    override func viewDidLayoutSubviews() {
        paymentTextField.frame = CGRect(x: 0, y: 0, width: self.cardViews.frame.width, height: self.cardViews.frame.height)
        paymentTextField.delegate = self
        cardViews.addSubview(paymentTextField)
    }

    //MARK:- Get token
    private func getToken(){
        showActivity()
        let cardParams = STPCardParams()
        guard let cardNumber = paymentTextField.cardNumber else {
            showMessage("Please enter card number")
          //  showMessage(<#T##String#>)
            return
        }
        cardParams.number = cardNumber
        cardParams.expMonth = UInt(paymentTextField.expirationMonth)
        cardParams.expYear = UInt(paymentTextField.expirationYear)
         print("cardssss-----\(String(describing: cardParams.number))\(cardParams.expMonth)\(cardParams.expYear)")
        guard let cvc = paymentTextField.cvc else {
            return
        }
        cardParams.cvc = cvc
        // Pass it to STPAPIClient to create a Token
        STPAPIClient.shared.createToken(withCard: cardParams) { token, error in
            guard let token = token else {
                // Handle the error
                return
            }
            let tokenID = token.tokenId
            print("test Token-----\(tokenID)")
           // self.saveCardDetailsApi()
            self.stripeToken = tokenID
            self.stripeChargesApi()
        }
   }

    

    func stripeChargesApi() {
        self.showActivity()
        let convertAmount = Int(UserStoreSingleton.shared.totalPrice ?? "")!
        let amountPay = convertAmount * 100
        UserStoreSingleton.shared.totalPrice = String(amountPay)
        let parameters : [String: Any] =  ["amount": amountPay,
                                           "source":stripeToken ?? "",
                                           "currency":"eur"]

        let postData = parameters.percentEncoded()
        var request = URLRequest(url: URL(string: "https://api.stripe.com/v1/charges")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer sk_test_51JjwCIFfJpDd1neCQ4c0uVKwxjMC2nG6rYdCrb5PvjJ092YNka8Gv1ZTFYUlnn0tumhGrlG0GkUPuocgcWsm0OT5007CLZ8SyV", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData
        let dataTask = URLSession.shared.dataTask(with: request) {
                data,response,error in

                guard let data = data else {
                   return
                }
                do {
                    let data = try JSONDecoder().decode(StripeChargesModel.self, from: data)
                    DispatchQueue.main.async { [self] in
                        print(data)
                        let getSuccess = data.status
                        print(getSuccess as Any)
                        self.hideActivity()
                        if data.paid ==  true{
                            self.TransactionStatus = "Success"
                            self.paymentStatus = data.id
                            self.savePaymentApi()

                        }else{
                            self.TransactionStatus = "Fail"
                            self.hideActivity()
                        }
                    }
                } catch let error {
                    self.showMessage(error.localizedDescription)
                    debugPrint(error.localizedDescription)
                    self.hideActivity()
                }

            }
            dataTask.resume()
    }

    func savePaymentApi() {
        self.showActivity()
        let params = ["job_id": myJobDetails.jobId ?? 0 ,
                      "user_id": myJobDetails.userId ?? 0,
                      "amount":UserStoreSingleton.shared.totalPrice ?? "",
                      "transaction_id": paymentStatus ?? "",
                      "status":TransactionStatus ?? ""] as [String : Any]

             let url = URL(string: "http://3.18.59.239:3000/api/v1/save-payment-details")
             var request = URLRequest(url: url!)
             request.httpMethod = "POST"
             request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
             //  print("Token is",UserStoreSingleton.shared.Token)
             request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
             guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                 return
             }
             request.httpBody = httpBody
             let session = URLSession.shared
             session.dataTask(with: request) { (data, response, error) in
                 if let Apiresponse = response {
                 }
                 if let data = data {
                     do {
                         let json =  try JSONDecoder().decode(savePaymentModel.self, from: data)
                        print(json)
                         DispatchQueue.main.async {
                            self.hideActivity()
                            let storyboard = UIStoryboard(name: "Booking", bundle: nil)
                            let secondVc = storyboard.instantiateViewController(withIdentifier: "RatingAlertViewController") as! RatingAlertViewController
                            secondVc.modalPresentationStyle = .fullScreen
                           self.present(secondVc, animated: true, completion: nil)
                    //        self.navigationController?.pushViewController(secondVc, animated: true)
                         }
                     }catch{
                        print("\(error.localizedDescription)")
                        self.hideActivity()
                   
                     }
                 }
             }.resume()
    }

    private func callingJobDetailsAPI() {
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-jobDetails/\(jobid ?? 0)")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(JobDetailsModel.self, from: data ?? Data())
                debugPrint(json)
                print(JobDetailsModel.self)
                DispatchQueue.main.async { [self] in
                    print(json)
                    if let myData = json.data {
                        print(myData)
                        self.myJobDetails = json.data
                        print(myJobDetails)
                    }
                }
            } catch {
                print(error)
            }

        }

        task.resume()
    }
    
    func saveCardDetailsApi() {
        self.showActivity()
        let params = ["card_holder_name": cardHolderNameTextFeild.text ?? "",
                      "card_number": paymentTextField.cardNumber,
                      "card_cvv": paymentTextField.cvc,
                      "card_expiry": paymentTextField.expirationMonth + paymentTextField.expirationYear] as [String : Any]

             let url = URL(string: "http://3.18.59.239:3000/api/v1/save-card-details")
             var request = URLRequest(url: url!)
             request.httpMethod = "POST"
             request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
             //  print("Token is",UserStoreSingleton.shared.Token)
             request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
             guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                 return
             }
             request.httpBody = httpBody
             let session = URLSession.shared
             session.dataTask(with: request) { (data, response, error) in
                 if let Apiresponse = response {
                     debugPrint(Apiresponse)
                 }
                 if let data = data {
                     do {
                         let json =  try JSONDecoder().decode(SaveCardModel.self, from: data)
                         DispatchQueue.main.async {
                            self.hideActivity()
                          
                         }
                     }catch{
                        print("\(error.localizedDescription)")
                        self.hideActivity()

                     }
                 }
             }.resume()
    }


    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
            var screenshotImage :UIImage?
            let layer = UIApplication.shared.keyWindow!.layer
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
            guard let context = UIGraphicsGetCurrentContext() else {return nil}
            layer.render(in:context)
            screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let image = screenshotImage, shouldSave {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            return screenshotImage
        }

    //MARK:- UITextField Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let formattedCreditCardNumber = cardno.text?.replacingOccurrences(of: "(\\d{4})(\\d{4})(\\d{4})(\\d+)", with: "$1 $2 $3 $4", options: .regularExpression, range: nil)
        print(formattedCreditCardNumber ?? "")
        cardno.text = formattedCreditCardNumber
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //no dots allowed
        if string == "." {
            return false
        }

        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
           
         
            if textField == cardno {
                if updatedText.count > 19 {
                   
                    return false
                }//test
            } else if textField == CVVTextFeild {
                if updatedText.count > 3 {
                    return false
                }
            } else if textField == expiryDateTextFeild {
                if updatedText.count > 2 {
                    return false
                }
                else if textField == monthExpiryTectField {
                    if updatedText.count > 2 {
                        return false
                    }
                }}
        }
        
        return true
    }
    
       override func viewWillAppear(_ animated: Bool) {
        let backButtonImage = UIImage(named: "BACK")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = .white
        tabBarController?.tabBar.isHidden = true
        continueButton.layer.cornerRadius = 10.0
        self.callingJobDetailsAPI()
     //   CheckTimeFunc()

    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false

    }

    //MARK: - UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 200, height: 100)
    }

    //MARK: - Interface Builder Actions
    @IBAction func continueButtonAction(_ sender: UIButton) {
        if cardHolderNameTextFeild.text == "" {
            showMessage("Please enter card holder number")
        }else{
            getToken()
         //   getCardNumbers()
        }
    }

    @IBAction func backBarButtonAction(_ sender: UIButton) {

    }
    
    @IBAction func bckBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }///

    //MARK: - Additional Helpers
    private func didTappedMakePaymentButton() {
        let stripeCardParameters = STPCardParams()
        stripeCardParameters.number = cardNumberTextFeild.text
        let expiryParameters = expiryDateTextFeild.text?.components(separatedBy: "/")
        stripeCardParameters.expMonth = UInt(expiryParameters?.first ?? "0") ?? 0
        stripeCardParameters.expYear = UInt(expiryParameters?.last ?? "0") ?? 0
        stripeCardParameters.cvc = CVVTextFeild.text

        STPAPIClient.shared.createToken(withCard: stripeCardParameters)
        {(token: STPToken?, error: Error?) in
            print("Printing Stripe Response---- \(String(describing: token?.allResponseFields))\n\n")
            print("Printing Stripe Token---- \(String(describing: token?.tokenId))")

            if error != nil {
                print(error?.localizedDescription)
            }

            if token != nil {
                print("Transaction Success--- here is the token--- \(String(describing: token?.tokenId))\n Card Type: \(String(describing: token!.card?.funding))\n \n send this token to your backend server to complete this payment")
     }

        }

    }

}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

