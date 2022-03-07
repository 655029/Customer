//
//  HomeViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 20/04/21.
//

import UIKit
import Designable
import CoreLocation
import SDWebImage

struct AllServices {
    var name: String
    var myName: String
}

class HomeViewController: HomeBaseViewController, CLLocationManagerDelegate, DissmissConfirmAlertViewController {
    func didTappedProceedButton(controller: ConfirmAlertViewController) {
        let mainStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
//        window?.rootViewController?.present(profileViewController, animated: true, completion: nil)
//        present(profileViewController, animated: true, completion: nil)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    
    
    // MARK: - Interface Outlets
    @IBOutlet weak var currentLocationButton: DesignableButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noJobImageVIew: UIImageView!
    @IBOutlet weak var noJobLabel: UILabel!
    
    
    // MARK: - Properties
    var getcreatedjob = [JobHistoryData]()
    var latitude: String?
    var longitude: String?
    var locationManager = CLLocationManager()
    static var homeSubcategoryList = NSMutableArray()
    static var subcatgoryIdString:[String] = []
    var jobId: Int?
    var firstNameString: String?
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //currentLocationButton.setTitle("\(UserStoreSingleton.shared.Address)", for: .normal)
        self.callingGetUserProfile()
        navigationItem.title = "Hello \(UserStoreSingleton.shared.name ?? "") "
        navigationController?.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil;
        currentLocationButton.addSpaceBetweenImageAndTitle(spacing: 10.0)
        currentLocationButton.setTitle(UserStoreSingleton.shared.Address, for: .normal)
        currentLocationButton.setTitleColor(UIColor.white, for: .normal)
        navigationController?.navigationBar.tintColor = .white
        tableView.register(UINib(nibName: "BookingsTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingsTableViewCell")
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            print("Location Enabled")
            locationManager.startUpdatingLocation()
        }
        else {
            print("Location not enabled")
        }
        NotificationCenter.default.addObserver(self, selector:#selector(viewWillAppear(_:)), name: NSNotification.Name(rawValue: "Forground"), object: nil)
        NotificationCenter.default.addObserver(self, selector : #selector(handleNotification(n:)), name : Notification.Name("notificationData"), object : nil)
        
    }
    
    
    @objc func handleNotification(n : NSNotification) {
        print(n)
        let dicData = n.object as! [String: String]
        let notificationType = dicData["notificationType"]!
        if notificationType == "complete" {
            let storyboard = UIStoryboard(name: "Booking", bundle: nil)
            let secondVc = storyboard.instantiateViewController(withIdentifier: "ConfirmAlertViewController") as! ConfirmAlertViewController
//            let navigationController = UINavigationController(rootViewController: secondVc)
            let navigationController = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "ConfirmAlertViewController"))
            secondVc.delegate = self
            navigationController.modalPresentationStyle = .overFullScreen
            navigationController.modalPresentationStyle = .overCurrentContext
            self.present(secondVc, animated: false, completion: nil)
        }
        
        else if notificationType == "accept" {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let navigationController = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController"))
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalPresentationStyle = .overCurrentContext
//            window?.rootViewController?.present(navigationController, animated: true, completion: nil)
            present(navigationController, animated: true, completion: nil)
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.callingGetUserProfile()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationItem.title = "Hello \(UserStoreSingleton.shared.name ?? "") "
        }
        navigationController?.navigationItem.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.callingGetUserCreatedJobsApi()
        tabBarController?.tabBar.isHidden = false
       if (UserStoreSingleton.shared.fromnotification)
       {
        //NotificationCenter.default.post(name: Notification.Name("confirmAlert"), object: nil)

//        let secondVc = storyboard.instantiateViewController(withIdentifier: "ConfirmAlertViewController") as! ConfirmAlertViewController
//
//                 let strJobId  = userInfo[AnyHashable("jobId")]
//                 let jobId = Int(strJobId as? String ?? "0")

                 UserStoreSingleton.shared.jobId = jobId

//        self.present(secondVc, animated: true, completion: nil)

        UserStoreSingleton.shared.fromnotification = false
     //            navigationController.modalPresentationStyle = .overFullScreen
     //            navigationController.modalPresentationStyle = .overCurrentContext
     //            window?.rootViewController?.present(navigationController, animated: true, completion: nil)
       }
       else{

       }


    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //get current location
        let userLocation = locations[0] as CLLocation
        
        //get latitude, longitude
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        print("latitude of current location\(latitude)")
        print("latitude of current location\(longitude)")
        UserStoreSingleton.shared.currentLat = latitude
        UserStoreSingleton.shared.currentLong = longitude
        
        // get address
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error == nil {
                print("Error in geoCoderLocation")
            }
            //            let placemark = placemarks! as [CLPlacemark] // sometime yha crash hota hai....
            guard let placemark = placemarks else {return}
            if (placemark.count > 0) {
                let placemark = placemarks![0]
                let locality = placemark.locality ?? ""
                let adminstartiveArea = placemark.subAdministrativeArea ?? ""
                let country = placemark.country ?? ""
                print("current addres:---- \(adminstartiveArea), \(locality), \(country)")
                UserStoreSingleton.shared.Address = ("\(adminstartiveArea), \(locality), \(country)")
                self.currentLocationButton.setTitle(UserStoreSingleton.shared.Address, for: .normal)
                
            }
            
        }
        
    }
    
    
    // MARK: - Additional Helpers
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
    
    func callingGetUserCreatedJobsApi() {
        self.showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-user-created-jobs")!,timeoutInterval: Double.infinity)
        print("\(UserStoreSingleton.shared.Token ?? "")")
        var Token = "\(UserStoreSingleton.shared.Token ?? "")"
        request.addValue(Token, forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.hideActivity()
            do {
                let json =  try JSONDecoder().decode(JobsHistoryModel.self, from: data ?? Data())
                DispatchQueue.main.async {
                    self.hideActivity()
                    print(json)
                    if json.data?.count == 0 {
                        self.showMessage("Data not Found")
                        self.getcreatedjob = []
                        self.tableView.isHidden = true
                        self.noJobImageVIew.isHidden = false
                        self.noJobLabel.isHidden = false
                        self.tableView.reloadData()
                    } else{
                        if let myData = json.data {
                            self.tableView.backgroundView = nil
                            print(myData)
                            self.getcreatedjob = myData
                            self.getcreatedjob.reverse()
                            self.showMessage(json.message ?? "")
                            self.tableView.isHidden = false
                            self.noJobImageVIew.isHidden = true
                            self.noJobLabel.isHidden = true
                            self.tableView.reloadData()
                        }
                    }
                    
                }
            } catch {
                        self.hideActivity()
                //                self.showMessage("error")
                print(error)
            }
        }
        
        task.resume()
    }


    func callingGetUserProfile() {
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
                    let Name = json.data?.name
                    if json.data?.first_name == nil {
                        let fullName = Name
                        let fullNameArr = fullName?.components(separatedBy: " ")
                        let firstName = fullNameArr?[0]
                        let lastName = fullNameArr?[1]
                        UserStoreSingleton.shared.name = firstName
                        UserStoreSingleton.shared.lastname
                    }
                    else {
                        UserStoreSingleton.shared.name = json.data?.first_name
                    }
                    UserStoreSingleton.shared.userID = json.data?.userId
                }
            } catch {
                print(error)
                self.hideActivity()
            }
        }
        task.resume()
    }
    

    private func callingDeleteJobApi() {
        let Url = String(format: "http://3.18.59.239:3000/api/v1/delete-job")
        guard let serviceUrl = URL(string: Url) else { return }

        let parameterDictionary =  ["job_id": jobId ?? ""] as [String: Any]

        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
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
                    let json = try JSONDecoder().decode(DeleteJobAPIModel.self, from: data)
                    print(json)
                    DispatchQueue.main.async {
                        let responseMessage = json.status;
                        if responseMessage == 200 {
                            self.tableView.reloadData()
                            self.showMessage(json.message ?? "")
                        }
                        else{

                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}


//MARK: - UITableViewDelegete Methods
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if getcreatedjob[indexPath.row].jobStatus?.lowercased() == "accept" || getcreatedjob[indexPath.row].jobStatus?.lowercased() == "inprogress" || getcreatedjob[indexPath.row].jobStatus?.lowercased() == "complete"{
            let data = getcreatedjob[indexPath.row]
            let storyborad = UIStoryboard(name: "Booking", bundle: nil)
            let secondVc = storyborad.instantiateViewController(withIdentifier: "BookingJobStatusViewController") as! BookingJobStatusViewController
            secondVc.dicData = data
            navigationController?.pushViewController(secondVc, animated: true)
        }
    }
}


// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getcreatedjob.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingsTableViewCell") as? BookingsTableViewCell else {
            fatalError()
        }
        
        print("Items",getcreatedjob[indexPath.row].jobStatus ?? "")
        if getcreatedjob[indexPath.row].jobStatus?.lowercased() == "open" || getcreatedjob[indexPath.row].jobStatus?.lowercased() == "cancel" || ((getcreatedjob[indexPath.row].providerId?.isEmpty) == true){
            cell.hireButton.isHidden = false
            cell.deleteButton.isHidden = false
            cell.editButton.isHidden = false
            cell.buttonStack.isHidden = false
            cell.hireButton.tag = indexPath.row
            cell.deleteButton.tag = indexPath.row
            cell.editButton.tag = indexPath.row
            cell.userImage.isHidden = true
            cell.userName.isHidden = true
            cell.ratingStarView.isHidden = true
            cell.timeImage.isHidden = true
            cell.dateImage.isHidden = true
            cell.selectedDay.isHidden = true
            cell.createdDateLabel.isHidden = true
            cell.selectedDate.isHidden = true
            cell.selectedPrice.isHidden = true
        }
        else if getcreatedjob[indexPath.row].jobStatus?.lowercased() == "request"{
            cell.hireButton.isHidden = false
            cell.userImage.isHidden = true
            cell.userName.isHidden = true
            cell.ratingStarView.isHidden = true
            cell.deleteButton.isHidden = false
            cell.buttonStack.isHidden = false
            cell.editButton.isHidden = false
            cell.deleteButton.addTarget(self, action: #selector(didTappedDeleteButton(_:)), for: .touchUpInside)
            cell.editButton.addTarget(self, action: #selector(didTappedEditButton(_:)), for: .touchUpInside)
            cell.hireButton.setTitle("REQUEST", for: .normal)
            cell.hireButton.isEnabled = false
            cell.hireButton.backgroundColor = .red
            cell.hireButton.setTitleColor(.white, for: .normal)
            cell.timeImage.isHidden = true
            cell.dateImage.isHidden = true
            cell.selectedDay.isHidden = true
            cell.createdDateLabel.isHidden = true
            cell.selectedDate.isHidden = true
            cell.selectedPrice.isHidden = true
        }
        else if (getcreatedjob[indexPath.row].providerDetails != nil) || getcreatedjob[indexPath.row].providerDetails?.userId != 0 {
            cell.hireButton.isHidden = true
            cell.deleteButton.isHidden = true
            cell.editButton.isHidden = true
            cell.buttonStack.isHidden = true
            cell.userImage.isHidden = false
            cell.userName.isHidden = false
            cell.ratingStarView.isHidden = false
            cell.ratingStarView.rating = getcreatedjob[indexPath.row].providerDetails?.rating ?? 2.4
            cell.timeImage.isHidden = false
            cell.dateImage.isHidden = false
            cell.createdDateLabel.isHidden = false
            cell.selectedDay.isHidden = false
            cell.selectedDate.isHidden = false
            cell.selectedPrice.isHidden = false
        }
        let url = URL(string: getcreatedjob[indexPath.row].image ?? "")
        cell.categoryImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if url == nil {
            cell.categoryImage.sd_setImage(with: url, placeholderImage: UIImage(named: "Lawn Mowing"))
        }else{
            cell.categoryImage.sd_setImage(with: url, placeholderImage: UIImage(named: "Lawn Mowing"))
        }
        cell.categoryname.text = getcreatedjob[indexPath.row].categoryName
        cell.locationName.text = getcreatedjob[indexPath.row].location
        cell.copyIcon.tag = indexPath.row
        cell.selectedPrice.text = "$\(getcreatedjob[indexPath.row].price ?? "")"
        let dateTime = getcreatedjob[indexPath.row].booking_date
        let date = String(dateTime?.dropLast(14) ?? "")
        cell.createdDateLabel.text = getDate(date: getcreatedjob[indexPath.row].booking_date ?? "")
        let datenDay = getcreatedjob[indexPath.row].day
        let dateDay = datenDay?.filter{!$0.isWhitespace}
        let result4 = String(dateDay?.dropFirst(2) ?? "")
        cell.selectedDay.text = getcreatedjob[indexPath.row].day
        cell.selectedDate.text = getcreatedjob[indexPath.row].time
        cell.mintLabel.text = getcreatedjob[indexPath.row].total_time
        latitude = getcreatedjob[indexPath.row].lat
        longitude = getcreatedjob[indexPath.row].lng
        cell.hireButton.tag = indexPath.row
        cell.collectionView.reloadData()
        let subcategoryId = getcreatedjob[indexPath.row].subcategoryId
        let subcategoryName = getcreatedjob[indexPath.row].categoryName
        if subcategoryId?.count ?? 0 > 0 {
            for i in 0...subcategoryId!.count - 1 {
                let id = subcategoryId![i].id
                
            }
        }
        cell.userName.text = getcreatedjob[indexPath.row].providerDetails?.first_name
        cell.userImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let userImageUrl = URL(string: getcreatedjob[indexPath.row].providerDetails?.image ?? "")
     
        cell.userImage.sd_setImage(with: userImageUrl, placeholderImage: UIImage(named: "upload profile picture"))
        //sd_setImage(with: userImageUrl, placeholderImage:UIImage(contentsOfFile:"upload profile picture"))
        let arr = getcreatedjob[indexPath.row].subcategoryId
        cell.arrSubCatgeory = arr ?? []
        cell.hireButton.addTarget(self, action: #selector(hireButtonAction(_:)), for: .touchUpInside)
        cell.copyIcon.addTarget(self, action: #selector(didTappedCopyIcon(_:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(didTappedDeleteButton(_:)), for: .touchUpInside)
        cell.editButton.addTarget(self, action: #selector(didTappedEditButton(_:)), for: .touchUpInside)
        cell.collectionView.reloadData()
        
        return cell
        
    }
    
    
    //MARK: - Objc Methods
    @objc func hireButtonAction(_ sender: UIButton) {
        let screenShotImage = takeScreenshot(false) ?? UIImage()
        let subcategoryId = getcreatedjob[sender.tag].subcategoryId
        let subcategoryName = getcreatedjob[sender.tag].categoryName
        UserStoreSingleton.shared.jobId = getcreatedjob[sender.tag].jobId
        if subcategoryId?.count ?? 0 > 0 {
            for i in 0...subcategoryId!.count - 1 {
                let id = subcategoryId![i].id
                HomeViewController.subcatgoryIdString.append(id!)
            }
        }
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController") as! ConfirmationViewController
        secondVc.ssImage = screenShotImage
        UserStoreSingleton.shared.jobId = getcreatedjob[sender.tag].jobId
        UserStoreSingleton.shared.totalPrice = getcreatedjob[sender.tag].price
        navigate(.providerList)
        
    }


    @objc func didTappedCopyIcon(_ sender: UIButton) {
        let location = getcreatedjob[sender.tag].location
        UIPasteboard.general.string = location
        showMessage("Copied")
    }

    @objc func didTappedDeleteButton(_ sender: UIButton) {
        let dialogMessage = UIAlertController(title: "Alert", message: "Are you sure? you want to delete this job", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            print("Delete button tapped")
            let deletedJobid = self.getcreatedjob[sender.tag].jobId
            self.jobId = deletedJobid
            self.getcreatedjob.remove(at: sender.tag).jobId
              //  self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.callingDeleteJobApi()
      })

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }

        dialogMessage.addAction(delete)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }

    @objc func didTappedEditButton(_ sender: UIButton) {
        let jobEdit = getcreatedjob[sender.tag].jobId
        print(jobEdit ?? "")
      //  comeFrom = "EditPost"
        selectJob_id = getcreatedjob[sender.tag].jobId
        navigate(.updateJob)
    }

    func getDate(date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //    dateFormatter.timeZone = TimeZone.current
        //    dateFormatter.locale = Locale.current
        let dateValue = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: dateValue)
    }

    //MARK: - TableViewDelegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension HomeViewController : fromNotification {
    func dissmissNotification(jobId: Int) {
        print("------Working-----")
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
        //        self.tabBarController?.tabBar.selectedItem = 1
        secondVc.jobid = jobId
        navigationController?.pushViewController(secondVc, animated: true)
    }
}
