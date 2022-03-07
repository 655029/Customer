//
//  ChooseSubServicesViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 18/04/21.
//

import UIKit
import SideMenu
import SwiftyJSON
import NVActivityIndicatorView


struct SelectedServices {
    var id: Int
    var name: String
}


protocol ViewControllerDelegateIt: class {
    func didTapNextButton(controller: ChooseSubServicesViewController)
}

class ChooseSubServicesViewController: ServiceBaseViewController  {
    weak var delegate: ViewControllerDelegateIt?


    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topLabel: UILabel!


    // MARK: - Properties
    var categoryId: Int?
    static var subcategoryList = NSMutableArray()
    static var selectedServiesArray: [String] = []
    var storeArray = NSArray()
    override var navigationController: BaseNavigationController? {
        return super.navigationController
    }
    var service: Service!
    var nameArray: [String] = []
    var selectedElement = [Int : String]()
    var arrayData:[SubCatgeoryModel] = []
    static var selectedServicesTitle: String?
    var selectedIndexPathForSelectedData: IndexPath?


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesigns()
        self.rightBarButton()
        topLabel.text = service.title
        callingSubServicesAPI()
        ChooseSubServicesViewController.selectedServicesTitle = topLabel.text
        nameArray.append("Lown Mowing")
        nameArray.append("Weed Removal")
        nameArray.append("Planting")
        nameArray.append("Gutter Service")
        nameArray.append("other")
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        storeArray = arrayData as NSArray
        print(storeArray)
    }

    override func viewWillAppear(_ animated: Bool) {
        ChooseSubServicesViewController.selectedServiesArray.removeAll()

    }


    // MARK: - Layout
    func rightBarButton() {
        let barButton = UIBarButtonItem(image: UIImage(named: "NEXT"), style: .done, target: self, action: #selector(rightButton(_:)))
        navigationItem.rightBarButtonItem = barButton
    }

    private func applyDesigns() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ChooseSubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "ChooseSubServicesTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.keyboardDismissMode = .onDrag
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! UploadProfilePictureViewController
        destinationViewController.labelName = topLabel.text ?? "nil"
    }


    // MARK: - User Interaction
    @IBAction func mainButtonToDissmissPresentController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func nextButtonAction(sender: UIButton) {
        if ChooseSubServicesViewController.selectedServiesArray.isEmpty == true {
            openAlert(title: "Alert", message: "Please select any Sub Category", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                print("Okay")
            }])
        }
        else {
            delegate?.didTapNextButton(controller: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    // MARK: - Additional Helpers
    @objc func rightButton(_ Sender: UIBarButtonItem) {
        navigate(.uploadProfilePicture)
    }

}

// MARK: - UITableViewDelegate
extension ChooseSubServicesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ChooseSubServicesTableViewCell
        cell.selectionDeselectionButton.isSelected.toggle()
        let indexPath = tableView.indexPathsForSelectedRows?.first
        let data = tableView.cellForRow(at: indexPath!) as? ChooseSubServicesTableViewCell
        let subcategoryId = arrayData[indexPath!.row].subcategoryId
        let subcategoryName = arrayData[indexPath!.row].subcategoryName
        let dic = NSMutableDictionary()
        dic.setValue(String(subcategoryId!), forKey: "id")
        dic.setValue(subcategoryName, forKey: "name")
        ChooseSubServicesViewController.subcategoryList.add(dic)
        let bh = data?.nameLable.text ?? ""

        if ChooseSubServicesViewController.selectedServiesArray.contains(bh) {
            let indexPathOfSelectedData = ChooseSubServicesViewController.selectedServiesArray.firstIndex(of: bh)
            ChooseSubServicesViewController.selectedServiesArray.remove(at: indexPathOfSelectedData!)
        }
        else {
            ChooseSubServicesViewController.selectedServiesArray.append(bh)
        }

        //        let value = (storeArray.object(at: indexPath!.row) as?  NSDictionary)?["subcategoryId"] as? Int
//        print(value)
//        let categoryname = (storeArray.object(at: indexPath!.row) as? NSDictionary)?["subcategoryName"] as? String
//        print(categoryname!)
    }


}

// MARK: - UITableViewDataSource
extension ChooseSubServicesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseSubServicesTableViewCell") as! ChooseSubServicesTableViewCell
        cell.nameLable.text = arrayData[indexPath.row].subcategoryName
//        let subcategoryId = arrayData[indexPath.row].subcategoryId
//        let subcategoryName = arrayData[indexPath.row].subcategoryName
//        ChooseSubServicesViewController.subcategoryList.append(SelectedServices(id: subcategoryId!, name: subcategoryName!))
        cell.selectionDeselectionButton.tag = indexPath.row
        cell.selectionDeselectionButton.addTarget(self, action: #selector(selectionMethod(_:)), for: .touchUpInside)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    @objc func selectionMethod(_ sender: UIButton) {
        sender.isSelected.toggle()
        selectedIndexPathForSelectedData = IndexPath(item: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: selectedIndexPathForSelectedData!) as! ChooseSubServicesTableViewCell
        let subcategoryId = arrayData[sender.tag].subcategoryId
        let subcategoryName = arrayData[sender.tag].subcategoryName
        let dic = NSMutableDictionary()
        dic.setValue(String(subcategoryId!), forKey: "id")
        dic.setValue(subcategoryName, forKey: "name")
        ChooseSubServicesViewController.subcategoryList.add(dic)
        print(cell.nameLable.text ?? "")

        if ChooseSubServicesViewController.selectedServiesArray.contains(cell.nameLable.text!) {
            let indexPathOfSelectedData = ChooseSubServicesViewController.selectedServiesArray.firstIndex(of: cell.nameLable.text!)
            ChooseSubServicesViewController.selectedServiesArray.remove(at: indexPathOfSelectedData!)
        }
        else {
            ChooseSubServicesViewController.selectedServiesArray.append(cell.nameLable.text!)
        }

    }

    func callingSubServicesAPI()  {
        self.showActivity()
        let Url = String(format: "http://3.18.59.239:3000/api/v1/sub-categories-list")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary =  ["categoryId": categoryId!] as [String: Any]
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
                //print(response)
            }
            guard let data = data else {return}
                do {
                     let json = try JSON(data: data)
                    let result = json["data"]
                    print(result)
                    self.storeArray = (json["data"] as? NSArray ?? [])
                    for arr in result.arrayValue {
                        self.arrayData.append(SubCatgeoryModel(json: arr))
                     }
                    DispatchQueue.main.async {
                        self.hideActivity()
                                self.tableView.reloadData()
                            }
                } catch {
                    print(error)

            }
        }.resume()

}

}
