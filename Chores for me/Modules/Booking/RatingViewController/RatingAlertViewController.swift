//
//  RatingAlertViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 20/07/21.
//

import UIKit
import Cosmos
import Toast_Swift


//protocol RatingAlertViewControllerDelegate: class {
//    func didTapSubmitButton(controller: RatingAlertViewControllerDelegate)
//}

class RatingAlertViewController: UIViewController {
    
    
    //MARK: - Interface Builder IBOutlets
    @IBOutlet weak private var myTextView: UITextView!
    @IBOutlet weak var cosmosRating: CosmosView!
//    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet var blurBGView: UIView!
    
    //MARK: - Properties
    var ratingData: NotificationData!
    var starRating: Double?
    var myJobDetails: JobDetailsdata!
    var dicData: [NotificationData] = []
//    var ssImage = UIImage()

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextView.layer.borderWidth = 1.5
        myTextView.layer.borderColor = UIColor.black.cgColor
        starRating = cosmosRating.rating
        cosmosRating.didFinishTouchingCosmos = didFinishTouchingCosmos(_:)
        //        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        //        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurEffectView.frame = view.bounds
        //        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //        view.addSubview(blurEffectView)
     //   blurBGView.blurView.setup(style: UIBlurEffect.Style.light, alpha: 0.9).enable()
        self.setupView()
        self.callingJobDetailsAPI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        self.callingJobDetailsAPI()
    }


    
    //MARK: - Interface Builder Actions
    @IBAction func skipButtonAction(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
        RootRouter().loadMainHomeStructure()
    }

//    func applyBlurEffect(image: UIImage){
//           let imageToBlur = CIImage(image: image)
//           let blurfilter = CIFilter(name: "CIGaussianBlur")
//           blurfilter?.setValue(8, forKey: kCIInputRadiusKey)
//           blurfilter?.setValue(imageToBlur, forKey: "inputImage")
//           let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
//           var blurredImage = UIImage(ciImage: resultImage)
//           let cropped:CIImage = resultImage.cropped(to: CGRect(x: 0, y: 0,width: (imageToBlur?.extent.size.width)!, height: imageToBlur?.extent.size.height ?? 0.0))
//           blurredImage = UIImage(ciImage: cropped)
//           self.backGroundImage.image = blurredImage

//       }

    @IBAction func submitButtonAction(_ sender: UIButton) {

        if starRating == 0 {
            showMessage("Please give rating again")
        }
        else {
            self.callingRatingAPI()
        }
        //        delegate?.didTapSubmitButton(controller: self)
        
        
    }
    
    
    //MARK: - Additional Helpers
    lazy var blurredView: UIView = {
        // 1. create container view
        let containerView = UIView()
        // 2. create custom blur view
        let blurEffect = UIBlurEffect(style: .extraLight)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
        customBlurEffectView.frame = self.view.bounds
        // 3. create semi-transparent black view
        let dimmedView = UIView()
        dimmedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        customBlurEffectView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        dimmedView.frame = self.view.bounds

        // 4. add both as subviews
        containerView.addSubview(customBlurEffectView)
       // containerView.addSubview(dimmedView)
        return containerView
    }()
    
    func setupView() {
        // 6. add blur view and send it to back
        view.addSubview(blurredView)
        view.sendSubviewToBack(blurredView)
    }
    
    func showMessage(_ withMessage : String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.cornerRadius = 5.0
        style.backgroundColor = .black
        style.messageFont = UIFont.boldSystemFont(ofSize: 15.0)
        self.view.clearToastQueue()
        self.view.makeToast(withMessage, duration: 2.0, position: .top, style: style)
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        starRating = rating
    }
    
    func callingRatingAPI() {
        let url = URL(string: "http://3.18.59.239:3000/api/v1/ratings")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        //  print("Token is",UserStoreSingleton.shared.Token)
        request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        let parameterDictionary =  ["userID": myJobDetails.userId ?? "", "ratingType": "0","providerID":  myJobDetails.providerDetails?.userId ?? "0","jobID": myJobDetails.jobId ?? "" ,"ratings": starRating ?? "","comments": myTextView.text ?? "Good" ] as [String: Any]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
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
                    let json =  try JSONDecoder().decode(RatingsModel.self, from: data)
                    DispatchQueue.main.async {
                        if json.status == 200 {
                            self.showMessage(json.message ?? "")
                            RootRouter().loadMainHomeStructure()
                        }
                        else {
                            self.showMessage(json.message ?? "")
                        }
                    }
                }catch{
                    print("\(error.localizedDescription)")
                    
                }
            }
        }.resume()
        
    }
    
    private func callingJobDetailsAPI() {
        let jobId = UserStoreSingleton.shared.jobId
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-jobDetails/\(jobId ?? 0)")!,timeoutInterval: Double.infinity)
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
    
}

/*
 //
 //  ChooseLocationFromMapViewController.swift
 //  Chores for me
 //
 //  Created by Bright Roots 2019 on 15/04/21.
 //

 import UIKit
 import SnapKit
 import GoogleMaps
 import SwiftyJSON

 protocol LocationDelegate: class
 {
     func childViewControllerResponse(location: String)
 }

 class ChooseLocationFromMapViewController: UIViewController, GMSMapViewDelegate {


     // MARK: - Outlets

     @IBOutlet weak var mapView: GMSMapView!
     @IBOutlet weak var searchBGView: UIView!

     // MARK: - Properties
     var transparentview =  UIView()
     let location: String? = ""
     var selectedLatitude:Double?
     var selectedLongitude:Double?
     private var searchController: UISearchController!
     public var longitude = Double()
     public var latitude = Double()
     var address: String?
     static var delegate: LocationDelegate?
     var geoCoder :CLGeocoder!

     lazy var mapButton : UIButton = {
         let  mapButton = UIButton()
         mapButton.translatesAutoresizingMaskIntoConstraints = false
         mapButton.setImage(UIImage(named: "NEXT BUTTON TO MAP SCREEN"), for: .normal)
         return mapButton
     }()

     lazy var pinImage : UIImageView = {
         let pin = UIImageView()
         pin.image = #imageLiteral(resourceName: "check (1)")
         return pin

     }()

   //  var mapView: GMSMapView!
     let zoom: Float = 12
     let marker = GMSMarker()
     let locationManager = CLLocationManager()


     // MARK: - View Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
       //  addSearchBar()
      //   addMapView()
       //  addButton()

         self.searchController = UISearchController(searchResultsController: nil)
         self.searchController.searchResultsUpdater = self
         self.searchController.dimsBackgroundDuringPresentation = false
                self.searchController.searchBar.delegate = self
                definesPresentationContext = true
                  self.searchBGView.addSubview(self.searchController.searchBar)
             //   self.searchBarPlaceholderView.addSubview(self.searchController.searchBar)
              //   self.searchController.searchBar.searchBaUISearchBar.StylehBarStyle.minimal
               //  self.searchController.searchBar.frame.size.width = self.searchBGView.frame.size.width
                self.searchController.searchBar.placeholder = " Search..."
                self.searchController.searchBar.frame.size.width = searchBGView.frame.size.width
               self.searchController.searchBar.sizeToFit()
     //    searchBGView.addSubview(searchController.searchBar)


         mapButton.addTarget(self, action: #selector(btnClicked(sender:)), for: .touchUpInside)
         mapView.delegate = self
         geoCoder = CLGeocoder()
         locationManager.delegate = self
         locationManager.requestWhenInUseAuthorization()
         //selectedLongitude.append(latitude)
         navigationController?.navigationBar.isHidden = true

      //   self.navigationController?.navigationBar.tintColor = .black
         let camera = GMSCameraPosition.camera(withLatitude:self.latitude, longitude: self.longitude, zoom: 12)
         self.mapView.bringSubviewToFront(pinImage)
         mapView.settings.compassButton = true
         mapView.settings.myLocationButton = true

         NotificationCenter.default.addObserver(self, selector: #selector(locationText(_:)), name: .locationName, object: nil)
     }

     override func viewWillAppear(_ animated: Bool) {
      //   mapView.animate(to: GMSCameraPosition(latitude: UserStoreSingleton.shared.currentLat ?? 0, longitude: UserStoreSingleton.shared.currentLong ?? 0, zoom: 15))
 //        CheckTimeFunc()

     }

     @objc func locationText(_ notification: Notification) {

     }

     @objc func btnClicked(sender:UIButton){
         if address != nil && address != "" {
             ChooseLocationFromMapViewController.delegate?.childViewControllerResponse(location: address!)
             UserStoreSingleton.shared.Address = address
             navigationController?.popViewController(animated: true)
         }

     }

     func addButton(){
         mapView.addSubview(mapButton)
         mapButton.imageEdgeInsets = UIEdgeInsets(top: 67, left: 67, bottom: 67, right: 67)
         mapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7.5).isActive = true
         mapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
         mapButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
         mapButton.widthAnchor.constraint(equalToConstant: 80).isActive = true

     }

     private func addSearchBar1() {
         let searchController = UISearchController(searchResultsController: nil)
         searchController.searchResultsUpdater = self
         searchController.obscuresBackgroundDuringPresentation = false
         searchController.searchBar.placeholder = "Search..."

         if #available(iOS 13.0, *) {
             searchController.searchBar.searchTextField.font = AppFont.font(style: .regular, size: 15)
             searchController.searchBar.searchTextField.textColor = UIColor.white
             searchController.searchBar.searchTextField.backgroundColor = UIColor.white
         }

         navigationItem.searchController = searchController
         definesPresentationContext = true
         searchController.searchBar.delegate = self
         self.searchController = searchController
     }

     // MARK: - Layout
     private func addSearchBar() {
         let searchController = UISearchController(searchResultsController: nil)
         searchController.searchResultsUpdater = self
         searchController.obscuresBackgroundDuringPresentation = false
         searchController.searchBar.placeholder = "Search location"
         if #available(iOS 13.0, *) {
             searchController.searchBar.searchTextField.font = AppFont.font(style: .regular, size: 15)
             searchController.searchBar.searchTextField.textColor = UIColor.white
             searchController.searchBar.searchTextField.backgroundColor = .white
         }
         searchController.searchBar.isUserInteractionEnabled = false
         searchController.searchBar.showsCancelButton = false
         searchController.searchBar.backgroundColor = .clear
         searchController.searchBar.setNewcolor(color: .white)

         if #available(iOS 13.0, *) {
             searchController.searchBar.searchTextField.clearButtonMode = .never
         } else {
             UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes
                 .updateValue(UIColor.white, forKey: NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue))
 //             Fallback on earlier versions
             if let searchField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                 searchField.clearButtonMode = .never
                 searchField.backgroundColor = .white
                 searchField.textColor = .white
             }
         }
         searchController.searchBar.searchFieldBackgroundPositionAdjustment = UIOffset(horizontal: 13, vertical: -42)
         navigationItem.searchController = searchController
         definesPresentationContext = true
         searchController.searchBar.delegate = self
         self.searchController = searchController
     //    searchBGView.addSubview(searchController.searchBar)
         self.searchBGView.addSubview(self.searchController.searchBar)
     }

     private func addMapView() {
         mapView = GMSMapView()
         view.addSubview(mapView)
         mapView?.snp.makeConstraints { (make) in
             make.edges.equalToSuperview()
         }

         let  markerImage = UIImageView()
         markerImage.image = UIImage(named: "job location")
         markerImage.frame = CGRect(x: (self.view.frame.size.width - 20)/2, y: (self.view.frame.size.height - 25)/2, width: 40, height: 45)
         view.addSubview(markerImage)
          mapView.isMyLocationEnabled = true
          mapView.settings.myLocationButton = true
         mapView.padding = UIEdgeInsets(top: 90, left: 0, bottom: view.frame.size.height, right: 10)
     }

     // MARK: - User Interaction

     // MARK: - Additional Helpers
 }

 // MARK: - UISearchResultsUpdating

 extension ChooseLocationFromMapViewController: UISearchResultsUpdating {

     func updateSearchResults(for searchController: UISearchController) {

     }
 }

 public extension UISearchBar {
     func setNewcolor(color: UIColor) {
         let clrChange = subviews.flatMap { $0.subviews }
         guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
         sc.textColor = color
     }
 }


 // MARK: - UISearchResultsUpdating

 extension ChooseLocationFromMapViewController: UISearchBarDelegate {
 }

 extension ChooseLocationFromMapViewController: CLLocationManagerDelegate {
     func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
         let lat = position.target.latitude
         let lng = position.target.longitude

         UserStoreSingleton.shared.currentLat = lat
         UserStoreSingleton.shared.currentLong = lng

         var location = CLLocation(latitude: lat, longitude: lng)
         geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
             if let placemarks = placemarks {
                 if (placemarks.first?.location) != nil{
                     //self.addressTextField.text = (placemarks.first?.name ?? "")+" "+(placemarks.first?.subLocality ?? " ")
                     if let addressDict = (placemarks.first?.addressDictionary as NSDictionary?){
                         let dict = JSON(addressDict)
                         // self. .text = dict["City"].stringValue
                         print("\(dict["City"].stringValue)")
                         var address:String = ""
                         for data in dict["FormattedAddressLines"].arrayValue{
                             address = address+" "+data.stringValue
                          //   self.searchController.searchBar.text = "\(address)"
                             ChooseLocationFromMapViewController.delegate?.childViewControllerResponse(location: address)
                             self.address = address

                         }
                     }
                 }
             }

         }
     }

     func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         guard status == .authorizedWhenInUse else {
             return
         }
         locationManager.startUpdatingLocation()
         mapView.isMyLocationEnabled = true
         mapView.settings.myLocationButton = true
         let mapView = GMSMapView()
          mapView.isMyLocationEnabled = true
          mapView.settings.myLocationButton = true
          mapView.padding = UIEdgeInsets(top: 50, left: 0, bottom: 200, right: 50)

     }

     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         guard let location = locations.last else {
             return
         }
 //        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
         self.mapView.isMyLocationEnabled = true
         mapView.animate(to: GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15))
         let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15);
         self.mapView.camera = camera
         let marker: GMSMarker = GMSMarker()
         let myCurrentLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
         marker.appearAnimation = .pop
         DispatchQueue.main.async { [self] in
             marker.map = mapView
             mapView.animate(to: GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15))
         }
         mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
         locationManager.stopUpdatingLocation()
     }

 }

 extension Notification.Name {
     static let locationName = Notification.Name("Location")

 }

 */
