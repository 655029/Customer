//
//  AllowLocationViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 05/08/21.
//

import UIKit
import AVFoundation
import SPPermissions
import CoreLocation

class AllowLocationViewController: UIViewController, CLLocationManagerDelegate {


    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var allowButton: UIButton!


    //MARK: - Properties
    let locationManager = CLLocationManager()


    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        allowButton.layer.cornerRadius = 10.0

    }


    //MARK: - Interface Builder Actions
    @IBAction func allowButtonAction(_ sender: UIButton) {
        if !CheckLocationPermision() {
            locationManager.delegate = self
            locationManager.requestLocation()
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
        else {
            RootRouter().loadMainHomeStructure()
//            showPermissionAlert()
        }
    }

    func CheckLocationPermision() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                return false
            }
        } else {
            return false
        }
    }


    //MARK: - Additional Helpers
    func showPermissionAlert(){
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
        showPermissionAlert()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.first != nil {
            print("location:: (location)")
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }
    }

}
//        if !hasLocationPermission() {
//            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions.", preferredStyle: UIAlertController.Style.alert)
//
//                    let okAction = UIAlertAction(title: "Allow", style: .default, handler: {(cAlertAction) in
//                        self.locationManager.delegate = self
//                        self.locationManager.requestWhenInUseAuthorization()
//                    })
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
//                    alertController.addAction(cancelAction)
//
//                    alertController.addAction(okAction)
//
//                    self.present(alertController, animated: true, completion: nil)
//                }
//        else {
//                    RootRouter().loadMainHomeStructure()
//
//        }
//
//    }
//
//    func hasLocationPermission() -> Bool {
//            var hasPermission = false
//            if CLLocationManager.locationServicesEnabled() {
//                switch CLLocationManager.authorizationStatus() {
//                case .notDetermined, .restricted, .denied:
//                    hasPermission = false
//                case .authorizedAlways, .authorizedWhenInUse:
//                    hasPermission = true
//                }
//            } else {
//                hasPermission = false
//            }
//            return hasPermission
//        }
//
//}

