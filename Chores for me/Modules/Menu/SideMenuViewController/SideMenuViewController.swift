//
//  SideMenuViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 24/04/21.
//

import UIKit
import Alamofire
import SDWebImage
import NVActivityIndicatorView
import Cosmos

class SideMenuViewController: UIViewController {
    
    enum Options: CaseIterable {
        //case id
        case paymentDetails
        //        case jobStatus
        case notification
        case share
        case logout
        
        var image: UIImage? {
            switch self {
            //            case .id:
            //                return UIImage(named: "id")
            case .paymentDetails:
                return UIImage(named: "ADD PAYMENT DETAILS-1")
            //            case .jobStatus:
            //                return UIImage(named: "job.status")
            case .notification:
                return UIImage(named: "notification.bel")
            case .share:
                return UIImage(named: "share")
            case .logout:
                return UIImage(named: "logout")
            }
        }
        
        var title: String {
            switch self {
            //            case .id:
            //                return "Chores ID-Card"
            case .paymentDetails:
                return "Add Payment Details"
            //            case .jobStatus:
            //                return "Job Status"
            case .notification:
                return "Notifications"
            case .share:
                return "Share"
            case .logout:
                return "Logout"
            }
        }
    }


    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gmailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var starRating: CosmosView!

    
    // MARK: - Properties
    

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
//        getUserProfile()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        navigationController?.navigationBar.isHidden = true
        starRating.settings.updateOnTouch = false

    }


    override func viewWillAppear(_ animated: Bool) {
        let socailUrlString = UserStoreSingleton.shared.socailProfileImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
        self.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.white
        let socailImageurl = URL(string: socailUrlString)
        self.profileImage.sd_setImage(with: socailImageurl, placeholderImage: UIImage(named: "upload profile picture"))
        getUserProfile()
    }
    

    // MARK: - User Interaction
    @IBAction func editButtonAction(_ sender: UIButton) {
        navigate(.EditButtonTapped)
    }


    // MARK: - Additional Helpers
    func showActivity() {
        let activityData = ActivityData(size: CGSize(width: 30, height: 30), type: .circleStrokeSpin, color: .white, backgroundColor: UIColor(named: "AppColor"))
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }

    func hideActivity() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
}


// MARK: - UITableViewDelegate
extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Options.allCases[indexPath.row] {
        //        case .id:
        //            dismiss(animated: true)
        //            navigate(.choresID)
        case .paymentDetails:
            dismiss(animated: true)
            navigate(.paymentList)
        case .notification:
            dismiss(animated: true)
            navigate(.notifications)
        case .share: break
//        dismiss(animated: true)
//         navigate(.choresID)
        case .logout:
            let customStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let logoutViewcontroller = customStoryboard.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController
            logoutViewcontroller.modalPresentationStyle = .fullScreen
            logoutViewcontroller.delegate = self
            navigationController?.present(logoutViewcontroller, animated: true, completion: nil)
//            navigate(.logout)
        }
    }
}


// MARK: - UITableViewDataSource
extension SideMenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Options.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") else {
            fatalError()
        }
        cell.imageView?.image = Options.allCases[indexPath.row].image
        cell.textLabel?.font = AppFont.font(style: AppFont.Poppins.semiBold, size: 15)
        cell.textLabel?.textColor = AppColor.primaryLabelColor
        cell.textLabel?.text = Options.allCases[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }


    //MARK: - Additional Helpers
    func getUserProfile() {
        self.showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-user-Profile")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(SetUpProfile.self, from: data ?? Data())
                debugPrint(json)
                DispatchQueue.main.async {
                    self.hideActivity()
                    UserStoreSingleton.shared.name = json.data?.first_name
                    let name = json.data?.name
                    if json.data?.first_name == nil {
                        let fullName = name
                        let fullNameArr = fullName?.components(separatedBy: " ")
                        let firstName = fullNameArr?[0]
                        let lastName = fullNameArr?[1]
                        self.nameLabel.text = firstName
                        UserStoreSingleton.shared.name = firstName
                        UserStoreSingleton.shared.lastname = lastName
                        UserStoreSingleton.shared.email = json.data?.email
                    }
                    else {
                        self.nameLabel.text = json.data?.first_name
                        UserStoreSingleton.shared.name = json.data?.first_name
                        UserStoreSingleton.shared.lastname = json.data?.last_name
                        UserStoreSingleton.shared.email = json.data?.email
                    }
                    UserStoreSingleton.shared.lastname = json.data?.last_name
                    self.gmailLabel.text = json.data?.email
                    _ = json.data?.image
                    self.starRating.rating = Double(json.data?.avgRatings ?? 0)
                    UserStoreSingleton.shared.userID = json.data?.userId
                    let photoUrl = URL(string: (json.data?.image ?? "" ))
                        UserStoreSingleton.shared.profileImage = json.data?.image
                    print(photoUrl as Any)
                    self.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.white
                    if UserStoreSingleton.shared.profileImage ==  "http://3.128.96.192:3000/profile.png" {
                        let socailUrlString = UserStoreSingleton.shared.socailProfileImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                        self.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.white
                        let socailImageurl = URL(string: socailUrlString)
                        self.profileImage.sd_setImage(with: socailImageurl, placeholderImage: UIImage(named: "upload profile picture"))
                    }
                    else {
                        self.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.white
                        self.profileImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "upload profile picture"))
                    }
                    
                   }
            } catch {
                self.hideActivity()

                print(error)
            }

        }
        task.resume()
    }

}

extension SideMenuViewController: DissmissLogoutViewController{
    func didTappedLogoutButton(controller: LogoutViewController) {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        if #available(iOS 13.0, *) {
            let rootVC = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(rootVC, animated: true)
        }
        else {
            let rootVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(rootVC, animated: true)
            
        }
    }
 }


