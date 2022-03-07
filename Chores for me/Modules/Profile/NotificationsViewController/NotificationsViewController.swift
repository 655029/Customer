//
//  NotificationsViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 24/04/21.
//

import UIKit
import Designable

class NotificationsViewController: BaseViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    var notificationArray: [NotificationData] = []
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Notification"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        //   tableView.rowHeight =  120//UITableView.automaticDimension
        //   tableView.estimatedRowHeight = 300
        tabBarController?.tabBar.isHidden = true
        let nib = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NotificationTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        self.callingGetAllNotificationAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Layout
    
    
    // MARK: - User Interaction
    @IBAction func rateButtonAction(_ sender: DesignableButton) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "RatingAlertViewController") as! RatingAlertViewController
        navigationController?.present(secondVc, animated: true, completion: nil)
    }
    
    
    // MARK: - Additional Helpers
    private func callingGetAllNotificationAPI() {
        self.showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-all-notification/0")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(NotificationAPIModel.self, from: data ?? Data())
                self.hideActivity()
                debugPrint(json)
                print(NotificationAPIModel.self)
                DispatchQueue.main.async {
                    self.hideActivity()
                    print(json)
                    if json.data?.count == 0 {
                        self.showMessage(json.message ?? "")
                        self.notificationArray = []
                    }
                    else{
                        if let myData = json.data {
                            print(myData)
                            self.notificationArray = myData
                            //                            self.showMessage(json.message ?? "")
                            self.tableView.reloadData()
                        }
                    }
                }
            } catch {
                self.showActivity()
                print(error)
            }
            
        }
        task.resume()
    }
    
}


// MARK: - UITableViewDelegate

// MARK: - UITableViewDataSource
extension NotificationsViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as? NotificationTableViewCell else {
            fatalError()
        }
        cell.ratingAndCheckReasonButton.tag = indexPath.row
        print(notificationArray)
        if notificationArray[indexPath.row].type == "complete" && notificationArray[indexPath.row].payment_status == "Not Done"  {
            cell.payButton.isHidden = false
            cell.ratingAndCheckReasonButton.isHidden = false
        }else if notificationArray[indexPath.row].type == "complete" {
            cell.ratingAndCheckReasonButton.isHidden = false
            cell.ratingAndCheckReasonButton.setTitle("Rate Now", for: .normal)
            cell.ratingAndCheckReasonButton.tag = indexPath.row
        }else if notificationArray[indexPath.row].type == "cancel-by-provider" {
            cell.ratingAndCheckReasonButton.isHidden = false
            cell.payButton.isHidden = true
            cell.ratingAndCheckReasonButton.setTitle("Check Reason", for: .normal)
            cell.timeLabel.text = notificationArray[indexPath.row].totalTime
        }
        //        if notificationArray[indexPath.row].type == "cancel-by-provider" {
        //            cell.ratingAndCheckReasonButton.isHidden = false
        //            cell.payButton.isHidden = true
        //            cell.ratingAndCheckReasonButton.setTitle("Check Reason", for: .normal)
        //            cell.timeLabel.text = notificationArray[indexPath.row].totalTime
        //        }
        //        else if notificationArray[indexPath.row].type == "complete" {
        //            cell.payButton.isHidden = true
        //            cell.ratingAndCheckReasonButton.isHidden = false
        //            cell.ratingAndCheckReasonButton.setTitle("Rate Now", for: .normal)
        //            cell.ratingAndCheckReasonButton.tag = indexPath.row
        //            cell.timeLabel.text = notificationArray[indexPath.row].totalTime
        //        }
        //        else if notificationArray[indexPath.row].type == "accept" {
        //            cell.payButton.isHidden = true
        //            cell.ratingAndCheckReasonButton.isHidden = true
        //            cell.timeLabel.text = notificationArray[indexPath.row].totalTime
        //        }
        //        else if notificationArray[indexPath.row].payment_status == "Not Done" && notificationArray[indexPath.row].type == "complete"{
        //            cell.payButton.isHidden = false
        //            cell.timeLabel.text = notificationArray[indexPath.row].totalTime
        //        }
        ////        else if notificationArray[indexPath.row].type == "inprogress" {
        ////            cell.payButton.isHidden = true
        ////            cell.ratingAndCheckReasonButton.isHidden = true
        ////            cell.timeLabel.text = notificationArray[indexPath.row].totalTime
        ////        }
        //        else if notificationArray[indexPath.row].payment_status == "Done" {
        //            cell.payButton.isHidden = true
        //            //cell.ratingAndCheckReasonButton.isHidden = true
        //            cell.timeLabel.text = notificationArray[indexPath.row].totalTime
        //        }
        //
        ////        else if notificationArray[indexPath.row].payment_status == "done" {
        ////            cell.payButton.isHidden = true
        ////            cell.timeLabel.text = notificationArray[indexPath.row].totalTime
        ////        }
        //
        //        else {
        //            cell.ratingAndCheckReasonButton.isHidden = true
        //         //   cell.payButton.isHidden = true
        //
        //
        //        }
        //
        cell.notificationTextLabel.text = notificationArray[indexPath.row].text
        cell.timeLabel.text = notificationArray[indexPath.row].totalTime
        cell.ratingAndCheckReasonButton.addTarget(self, action: #selector(didTappedRatingButton(_:)), for: .touchUpInside)
        cell.payButton.addTarget(self, action: #selector(didTappedPayButton(_:)), for: .touchUpInside)
        return cell
    }
    
    
    @objc func didTappedRatingButton(_ sender: UIButton) {
        let screenShotImage = takeScreenshot(false) ?? UIImage()
        if notificationArray[sender.tag].type?.lowercased() == "complete" {
            let storyboard = UIStoryboard(name: "Booking", bundle: nil)
            let secondVc = storyboard.instantiateViewController(withIdentifier: "RatingAlertViewController") as! RatingAlertViewController
            secondVc.ratingData = notificationArray[sender.tag]
            UserStoreSingleton.shared.jobId = notificationArray[sender.tag].job_id
            UserStoreSingleton.shared.userID = notificationArray[sender.tag].user_id
            UserStoreSingleton.shared.providerId = notificationArray[sender.tag].provider_id
            secondVc.modalPresentationStyle = .fullScreen
            secondVc.modalPresentationStyle = .overCurrentContext
            //            secondVc.ssImage = screenShotImage
            navigationController?.present(secondVc, animated: true, completion: nil)
        }
        else {
            let cancelReason = notificationArray[sender.tag].cancel_reason
            UserStoreSingleton.shared.cancelReason = cancelReason
            navigate(.CancelReasonPage)
        }
        
    }
    
    @objc func didTappedPayButton(_ sender: UIButton) {
        let screenShotImage = takeScreenshot(false) ?? UIImage()
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
        secondVc.ratingData = notificationArray[sender.tag]
        secondVc.jobid = notificationArray[sender.tag].job_id
        navigationController?.pushViewController(secondVc, animated: true)
        //        navigate(.checkOut)
        
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

