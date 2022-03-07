//
//  CancelPaymentViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 09/12/21.
//

import UIKit
import Stripe
import StripeCore


var canceljobId : Int?
class CancelPaymentViewController: BaseViewController, STPPaymentCardTextFieldDelegate,UITextFieldDelegate {

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

    let paymentTextField = STPPaymentCardTextField()
    var stripeToken: String?
    var paymentStatus: String?
    var TransactionStatus: String?
    var jobid: Int?
    var myJobDetails: JobDetailsdata!
    var dicData: JobHistoryData!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        callingGetUserDetailsAPI()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        paymentTextField.postalCodeEntryEnabled = false
        navigationController?.navigationItem.title = "Payment mode"
        navigationController?.navigationBar.tintColor = .white
       // tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLayoutSubviews() {
        paymentTextField.frame = CGRect(x: 0, y: 0, width: self.cardViews.frame.width, height: self.cardViews.frame.height)
        paymentTextField.delegate = self
        cardViews.addSubview(paymentTextField)
    }


    private func callingGetUserDetailsAPI() {
        let jobId = canceljobId
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-jobDetails/\(jobId ?? 218)")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    let json =  try JSONDecoder().decode(JobDetailsModel.self, from: data ?? Data())
                    debugPrint(json)
                      print(JobDetailsModel.self)
                    DispatchQueue.main.async {
                        print(json)
                            if let myData = json.data {
                                print(myData)
                                self.myJobDetails = json.data
                            }
                    }
                } catch {
                    print(error)
                }

            }
                task.resume()
         }
    //MARK:- Get token
    private func getToken(){
        showActivity()
        let cardParams = STPCardParams()
        guard let cardNumber = paymentTextField.cardNumber else {
            showMessage("Please enter card number")
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
        let convertAmount = 5
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
                     debugPrint(Apiresponse)
                 }
                 if let data = data {
                     do {
                         let json =  try JSONDecoder().decode(savePaymentModel.self, from: data)
                         DispatchQueue.main.async {
                            self.hideActivity()
                            RootRouter().loadMainHomeStructure()
                         }
                     }catch{
                        print("\(error.localizedDescription)")
                        self.hideActivity()

                     }
                 }
             }.resume()
    }

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

}
