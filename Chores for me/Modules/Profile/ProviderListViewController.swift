//
//  ProviderListViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 15/07/21.
//

import UIKit
import Designable
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import SDWebImage

struct Provider {
    var name: String
    var address: String
}

class ProviderListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {


    //MARK: - Properties
    private var productList: [Provider] = []
    var arrayData:[ProviderListModel] = []


    //MARK: - Interface Builder Outlets
    @IBOutlet weak var providerListNearByYouButton: DesignableButton!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var topLabel: UILabel!


    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.tintColor = .white
        self.navigationItem.setHidesBackButton(true, animated: true)
     //   providerListNearByYouButton.addSpaceBetweenImageAndTitle(spacing: 10.0)
        self.applyFinishingTouchesToUIElements()
        self.setUpDataSource()
        self.callingProviderListAPI()
     }


    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
     //   backButton.isHidden = true
    }



    //MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayData.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderListTableViewCell", for: indexPath) as! ProviderListTableViewCell
        cell.viewProfileButton.tag = indexPath.row
        cell.viewProfileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        let providerImageUrl = URL(string: arrayData[indexPath.row].image ?? "")
        cell.productImage.sd_imageIndicator = SDWebImageActivityIndicator.gray

        cell.productImage.sd_setImage(with: providerImageUrl, placeholderImage:UIImage(contentsOfFile:"outdoor_home_service.png"))
        cell.productNameLabel.text = arrayData[indexPath.row].subcategoryName
        cell.productNameLabel.text = arrayData[indexPath.row].first_name
        cell.productLocationLabel.text = arrayData[indexPath.row].location_address
        cell.starRating.rating = arrayData[indexPath.row].rating ?? 2.5
        cell.layer.cornerRadius = 4.0
        tableView.reloadRows(at: [indexPath], with: .automatic)

        return cell
    }


    //MARK: - Interface Builder Actions
    @objc func profileButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if #available(iOS 13.0, *) {
            let vc = storyboard.instantiateViewController(identifier: "ProfileTapedViewController") as! ProfileTapedViewController
            vc.dicData = arrayData[sender.tag]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileTapedViewController") as! ProfileTapedViewController
            vc.dicData = arrayData[sender.tag]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func backButton(_ sender: UIButton) {
        RootRouter().loadMainHomeStructure()
    }


    //MARK: - Helpers
    private func applyFinishingTouchesToUIElements() {
        providerListNearByYouButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate)

        let nib = UINib(nibName: "ProviderListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProviderListTableViewCell")

        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableView.automaticDimension

    }

    private func setUpDataSource() {
        let providers =  ["Rohit Kaushal", "Hitesh Verma", "Hitesh Verma", "Rohit Kaushal", "Rohit Kaushal"]

        for name in providers {
            productList.append(Provider(name: name, address: "#4812 sector-70,Mohali chandigarh"))
        }
    }

    private func callingProviderListAPI() {
        self.showActivity()
            let Url = String(format: "http://3.18.59.239:3000/api/v1/provider-list")
            guard let serviceUrl = URL(string: Url) else { return }
        var strSubcategory = [String]()


        if SideMenuSubServicesTableViewController.subcategoryList.count > 0 {
//            let dic = SideMenuSubServicesTableViewController.subcategoryList as! NSDictionary
//            let str = dic.value(forKey: "id") as! String
//            strSubcategory.append(str)
        for i in 0...SideMenuSubServicesTableViewController.subcategoryList.count - 1 {
            let dic = SideMenuSubServicesTableViewController.subcategoryList[i] as! NSDictionary
            let str = dic.value(forKey: "id") as! String
            strSubcategory.append(str)
        }
            
        }
        else {
            strSubcategory = HomeViewController.subcatgoryIdString
        }

        let parameterDictionary =  ["lat": String(UserStoreSingleton.shared.currentLat!), "lng": String(UserStoreSingleton.shared.currentLong!),"subcategoryId": strSubcategory.joined(separator: ",")] as [String: Any]
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
                if response != nil {
                    print(response)
                }
                guard let data = data else {return}
                    do {
                         let json = try JSON(data: data)
                        let result = json["data"]
                        print(result)
                        for arr in result.arrayValue {
                            self.arrayData.append(ProviderListModel(json: arr))
                            print(self.arrayData)
                         }
                        DispatchQueue.main.async {
                            self.hideActivity()
                            if self.arrayData.count == 0 {
                                self.showMessage("No Providers Found")
                            }
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)

                }
            }.resume()

    }

    private func callingRatingsAPI() {
                let Url = String(format: "http://3.18.59.239:3000/api/v1/ratings")
                guard let serviceUrl = URL(string: Url) else { return }
        let cell = ProviderListTableViewCell()
        let selIndex = cell.SleectedIndexValue()
        let parameterDictionary =  ["userID": UserStoreSingleton.shared.userID ?? "",
                                    "ratingType": "0",
                                    "providerID": arrayData[0].userId ?? "",
                                    "jobID": UserStoreSingleton.shared.jobId ?? "",
                                    "ratings": "",
                                    "comments": ""] as [String: Any]
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
                    if response != nil {
                        print(response)
                    }
                    guard let data = data else {return}
                        do {
                             let json = try JSON(data: data)
                            let result = json["data"]
                            print(result)
                            DispatchQueue.main.async {
                            }
                        } catch {
                            print(error)

                    }
                }.resume()
    }
    }



