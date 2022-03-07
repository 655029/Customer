//
//  ChooseYourServiceViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 16/04/21.
//

import UIKit
import Designable
import SideMenu
import SDWebImage
import NVActivityIndicatorView

struct Service {
    var title: String
    var image: UIImage

    init(title: String, image: UIImage) {
        self.title = title
        self.image = image
    }


    static var services: [Service] {
        var services: [Service] = []
        services.append(Service(title: "Outdoor Home Service", image: UIImage(named: "outdoor_home_service")!))
        services.append(Service(title: "House cleaning", image: UIImage(named: "house_cleaning_service")!))
        services.append(Service(title: "Item Disposal", image: UIImage(named: "item_disposal_service")!))
        services.append(Service(title: "Custom", image: UIImage(named: "CUSTOM")!))
        return services
    }
}


class ChooseYourServiceViewController: ServiceBaseViewController, ViewControllerDelegateIt, ViewControllerDelegateForDissmiss {
    func didTapPlusButton(controller: ServiceBaseViewController) {
        navigate(.addCustomCategory)
    }

    func didTapNextButton(controller: ChooseSubServicesViewController) {
        navigate(.uploadProfilePicture)
    }


    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topView: DesignableView!
    

    // MARK: - Properties
    var menu: SideMenuNavigationController?
    var menuForSubserices: SideMenuNavigationController?
    var categoryDict = NSArray()
    override var navigationController: BaseNavigationController? {
        return super.navigationController
    }


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavbarRightButton()
        NotificationCenter.default.addObserver(self, selector: #selector(didTappedNextButtonOnSideMenu(n:)), name: NSNotification.Name(rawValue: "callBack"), object: nil)
//        menu = SideMenuNavigationController(rootViewController: ChooseSubServicesViewController())
        menu?.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
//        SideMenuManager.default.leftMenuNavigationController = menu

        topView.roundedCorners(corners: [.leftBottom, .rightBottom], with: 30)
        navigationController?.navigationBar.tintColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ServiceCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        self.callingCategoryListAPI()
    }

    @objc func didTappedNextButtonOnSideMenu(n: Notification) {
        print("Opened")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
        menuForSubserices = SideMenuNavigationController(rootViewController: SideMenuSubServicesTableViewController())
        menuForSubserices?.leftSide = true
        menuForSubserices?.setNavigationBarHidden(false, animated: true)
        menuForSubserices?.navigationItem.title = "Hello"
        menuForSubserices?.statusBarEndAlpha = 0
        menuForSubserices?.menuWidth = 280
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.leftMenuNavigationController = menuForSubserices
//        SideMenuSubServicesTableViewController.categoryId = nil
        callingCategoryListAPI()
        tabBarController?.tabBar.isHidden = false
   //     CheckTimeFunc()
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("alejfghoquefbpiqefjbqeri;fjbeqrifbqer;fer")
    }


    // MARK: - Layout

    // MARK: - User Interaction

    // MARK: - Additional Helpers
}

// MARK: - UICollectionViewDelegate

extension ChooseYourServiceViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {


        //MARK:- For Side Menu
        let value = (categoryDict.object(at: indexPath.row) as?  NSDictionary)?["categoryId"] as? Int
        print(value as Any)
        let categoryname = (categoryDict.object(at: indexPath.row) as? NSDictionary)?["categoryName"] as? String
        print(categoryname!)
        UserStoreSingleton.shared.categoryId = value
        UserStoreSingleton.shared.categoryName = categoryname
        let categoryId:[String: Int?] = ["categoryId": value]
        let serviceName = Service.services[indexPath.row].title
        SideMenuSubServicesTableViewController.firstTimeSelectedService = serviceName
        let selectedServiceName:[String: String] = ["serviceName": serviceName]
        SideMenuSubServicesTableViewController.firstCategoryId = value
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openSideMenuOption"), object: nil)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoryid"), object: nil, userInfo: categoryId as [AnyHashable : Any]);

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedServiceName"), object: nil, userInfo: selectedServiceName)

        

        present(menuForSubserices!, animated: true, completion: nil)


        //MARK:- For Present View Controller
//        let value = (categoryDict.object(at: indexPath.row) as?  NSDictionary)?["categoryId"] as? Int
//        print(value)
//
//        let categoryname = (categoryDict.object(at: indexPath.row) as? NSDictionary)?["categoryName"] as? String
//        print(categoryname!)
//        UserStoreSingleton.shared.categoryId = value
//        UserStoreSingleton.shared.categoryName = categoryname
//
//        if indexPath.item == 3 {
//            let storyboard = UIStoryboard(name: "Service", bundle: nil)
//            let secondVc = storyboard.instantiateViewController(withIdentifier: "AddCustomViewViewController") as? AddCustomViewViewController
//            secondVc?.service = Service.services[indexPath.item]
//            secondVc?.delegate = self
//            present(secondVc!, animated: true, completion: nil)
//        }
//        else {
//        let storyboard = UIStoryboard(name: "Service", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ChooseSubServicesViewController") as? ChooseSubServicesViewController
//            vc?.delegate = self
//            vc?.categoryId = value
//        vc?.service = Service.services[indexPath.item]
//        present(vc!, animated: false, completion: nil)
//        }

    }

}

// MARK: - UICollectionViewDataSource

extension ChooseYourServiceViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryDict.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as? ServiceCollectionViewCell else {
            fatalError()
        }
        cell.configure(with: Service.services[indexPath.item])
        let categoryname = (categoryDict.object(at: indexPath.row) as? NSDictionary)?["categoryName"] as? String
        cell.serviceTitleLabel.text = categoryname


        return cell
    }

    func callingCategoryListAPI() {
        self.showActivity()
        let url = URL(string: "http://3.18.59.239:3000/api/v1/categories-list")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data{
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let status = json["status"] as? Int, status == 200 {
                            DispatchQueue.main.async {
                                self.hideActivity()
                                let content = json["data"] as? NSDictionary
                               print(content as Any)
                               self.categoryDict = (json["data"] as? NSArray ?? [])
                               print(self.categoryDict)
                                self.collectionView.reloadData()
                            }

                            }
                        }

                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }

    }

// MARK: - UICollectionViewDelegateFlowLayout

extension ChooseYourServiceViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) - 16
        return CGSize(width: (width / 2), height: (width / 2))
    }


}



