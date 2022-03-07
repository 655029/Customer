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
import GoogleMaps
import GooglePlaces
import CoreLocation

protocol LocationDelegate: class
{
    func childViewControllerResponse(location: String)
}

class ChooseLocationFromMapViewController: BaseViewController, GMSMapViewDelegate {


    // MARK: - Properties
    var transparentview =  UIView()
    let location: String? = ""
    var selectedLatitude:Double?
    var selectedLongitude:Double?
    var resultsViewController: GMSAutocompleteResultsViewController?
    let pickup_autocompleteController = GMSAutocompleteViewController()
    var searchController: UISearchController?
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

    lazy var backView: UIView = {
        let backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = UIColor.black
        return backView
    }()

    lazy var markerImage : UIImageView = {
        let imge =  UIImageView()
        imge.image = #imageLiteral(resourceName: "job location")
        imge.translatesAutoresizingMaskIntoConstraints = false
        return imge
    }()


    var mapView: GMSMapView!
    let zoom: Float = 12
    let marker = GMSMarker()
    let locationManager = CLLocationManager()


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapView()
        addButton()
        addMarkerImage()
        mapButton.addTarget(self, action: #selector(btnClicked(sender:)), for: .touchUpInside)
        geoCoder = CLGeocoder()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.navigationController?.navigationBar.tintColor = .black
        self.view.backgroundColor = .black
        mapView.settings.myLocationButton = true
        NotificationCenter.default.addObserver(self, selector: #selector(locationText(_:)), name: .locationName, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        mapView.animate(to: GMSCameraPosition(latitude: UserStoreSingleton.shared.currentLat ?? 0, longitude: UserStoreSingleton.shared.currentLong ?? 0, zoom: 15))
        self.navigationController?.navigationBar.tintColor = UIColor.white
        addBackView()
        //     CheckTimeFunc()

    }

    override func viewDidLayoutSubviews() {
        mapView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mapView.delegate = self
        //  mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 50)
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
        mapButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mapButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        let centerXConstraint = NSLayoutConstraint(item: mapButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 154)
        let centerYConstraint = NSLayoutConstraint(item: mapButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: -200)
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
    }


    // MARK: - Layout
    private func addSearchBar() {
        var searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        resultsViewController?.delegate = self
        resultsViewController = GMSAutocompleteResultsViewController()
        searchController.searchBar.backgroundColor = .white
        searchController.obscuresBackgroundDuringPresentation = false
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        searchController.searchBar.placeholder = "Search location"
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.font = AppFont.font(style: .regular, size: 15)
            searchController.searchBar.searchTextField.textColor = UIColor.white
            searchController.searchBar.searchTextField.backgroundColor = .white
        }
        searchController.searchBar.isUserInteractionEnabled = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.backgroundColor = .white
//        searchController.searchBar.setNewcolor(color: .black)


        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.clearButtonMode = .never
        } else {
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes
                .updateValue(UIColor.black, forKey: NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue))
            //             Fallback on earlier versions
            if let searchField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                searchField.clearButtonMode = .never
                searchField.backgroundColor = .white
                searchField.textColor = .black
            }
        }
        searchController.searchBar.searchFieldBackgroundPositionAdjustment = UIOffset(horizontal: 13, vertical: -42)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        self.searchController = searchController
    }


    // MARK: - Additional Helpers
    private func addMapView() {
        mapView = GMSMapView()
        view.backgroundColor = UIColor.white
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.addToNavbar()
    }

    func addMarkerImage(){
        view.addSubview(markerImage)
        let centerXConstraint = NSLayoutConstraint(item: markerImage, attribute: .centerX, relatedBy: .equal, toItem: mapView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: markerImage, attribute: .centerY, relatedBy: .equal, toItem: mapView, attribute: .centerY, multiplier: 1.0, constant: 32)
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
    }

    func addBackView() {
        view.addSubview(backView)
        backView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backView.widthAnchor.constraint(equalToConstant: 20).isActive = true


    }

    // MARK: - User Interaction
    func addToNavbar(){
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.backgroundColor = .black
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        if #available(iOS 13.0, *) {
            searchController?.searchBar.searchTextField.textColor = .white
            searchController?.searchBar.searchTextField.leftView?.tintColor = .black
        } else {
            searchController?.searchBar.tintColor = .black

        }
        definesPresentationContext = true
        searchController?.hidesNavigationBarDuringPresentation = false

    }

    func locateWithLong(lon: String, andLatitude lat: String, andAddress address: String) {
        DispatchQueue.main.async {
            let latDouble = Double(lat)
            let lonDouble = Double(lon)
            self.mapView.clear()
            let position = CLLocationCoordinate2D(latitude: latDouble ?? 20.0, longitude: lonDouble ?? 10.0)
            let marker = GMSMarker(position: position)
            let camera = GMSCameraPosition.camera(withLatitude: latDouble ?? 20.0, longitude: lonDouble ?? 10.0, zoom: 15)
            self.mapView.camera = camera
            //     self.searchButton.setTitle(address, for: .normal)
            marker.map = self.mapView
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude

        print(lat)
        print(long)
        latitude = lat
        longitude = long
        let start_position = CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        let marker1 = GMSMarker(position: start_position)
        let circleCenter = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        let Pcirc = GMSCircle(position: circleCenter, radius: 2000)
        Pcirc.fillColor = UIColor.green.withAlphaComponent(0.5)
        Pcirc.map = mapView


        let camera = GMSCameraPosition.camera(withLatitude:latitude, longitude:longitude, zoom: 15)
        mapView.camera = camera

        pickup_autocompleteController.tintColor = .red
        pickup_autocompleteController.dismiss(animated: true, completion: nil)
    }
}


//MARK: Extentions

extension ChooseLocationFromMapViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(place.formattedAddress ?? "")")
        print("Place attributions: \(String(describing: place.attributions))")
        self.searchController?.searchBar.text? = "\(place.formattedAddress ?? "")"
        print("self.searchController?.searchBar.text: \(String(describing: self.searchController?.searchBar.text))")
        geoCoder.geocodeAddressString(place.formattedAddress ?? "") {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            print("Lat: \(lat), Lon: \(lon)")
            self.mapView.animate(to: GMSCameraPosition(latitude: lat ?? 0.0, longitude: lon ?? 0.0, zoom: 15))
        }
        dismiss(animated: true, completion: nil)
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


// MARK: - UISearchResultsUpdating

extension ChooseLocationFromMapViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

    }
}

//public extension UISearchBar {
//    func setNewcolor(color: UIColor) {
//        let clrChange = subviews.flatMap { $0.subviews }
//        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
//        sc.textColor = color
//    }
//}


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
                            self.searchController?.searchBar.text = "\(address)"
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
   }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        //      mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
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
