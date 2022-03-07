//
//  PaymentListViewController.swift
//  Chores for me
//
//  Created by Ios Mac on 20/11/21.
//

import UIKit

class PaymentListViewController: BaseViewController {

    @IBOutlet weak var notificationTableView: UITableView!
    
    
    // MARK: - Properties
    var cardListArray: [CardDataDetails] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Card Lists"
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        notificationTableView.rowHeight = 80
        tabBarController?.tabBar.isHidden = true
        self.notificationTableView.tableFooterView = UIView()
        getCardDetailsAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        self.getCardDetailsAPI()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    private func getCardDetailsAPI() {
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-card-details")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(GetCardDetailsModel.self, from: data ?? Data())
                debugPrint(json)
                print(GetCardDetailsModel.self)
                DispatchQueue.main.async {
                    self.hideActivity()
                    print(json)
                    if json.data?.count == 0 {
                        self.showMessage(json.message ?? "")
                        self.cardListArray = []
                    }
                    else{
                        if let myData = json.data {
                            print(myData)
                             self.cardListArray = myData
//                            self.showMessage(json.message ?? "")
                            self.notificationTableView.reloadData()
                        }
                    }
                }
            } catch {
                print(error)
            }

        }

        task.resume()
    }
}

extension PaymentListViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PaymentListTableViewCell
        
        cell.cardHoldername.text = cardListArray[indexPath.row].card_holder_name
        cell.cardNumber.text = cardListArray[indexPath.row].card_number
        return cell
        
    }
    
    
}
