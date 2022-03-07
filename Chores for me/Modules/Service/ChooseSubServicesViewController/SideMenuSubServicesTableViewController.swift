//
//  SideMenuSubServicesTableViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 13/10/21.


import UIKit
import SwiftyJSON
import Toast_Swift
import NVActivityIndicatorView
import SDWebImage

protocol SideMenuDissmiss: class {
    func didTapNextButton(controller: SideMenuSubServicesTableViewController)
}

class SideMenuSubServicesTableViewController: UITableViewController {


    // MARK: - Properties
    var categoryId: Int?
    static var firstCategoryId: Int?
    static var subcategoryList = NSMutableArray()
    static var selectedServiesArray: [String] = []
    static var selectedServiesImagesArray: [UIImage] = []

    var storeArray = NSArray()
    var service: Service!
    var nameArray: [String] = []
    var selectedElement = [Int : String]()
    var arrayData:[SubCatgeoryModel] = []
    static var selectedServicesTitle: String?
    var selectedIndexPathForSelectedData: IndexPath?
    static var firstTimeSelectedService: String?
    var getSelectedService: String?
    weak var delegate: SideMenuDissmiss?

    lazy var nextButton: UIButton = {
        let nextButton = UIButton(type: .system)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.isHidden = true
        nextButton.layer.cornerRadius = 10.0
        nextButton.frame.size = CGSize(width: 100, height: 45)
        return nextButton
    }()

    weak var rightBarButton: UIButton!


    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuSubServicesTableViewController.selectedServiesImagesArray.removeAll()
        categoryId = UserStoreSingleton.shared.categoryId
        NotificationCenter.default.addObserver(self, selector: #selector(openSideMenu(n:)), name: Notification.Name("openSideMenuOption"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getcategoryId(n:)), name: NSNotification.Name(rawValue: "categoryid"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectedServiceName(n:)), name: NSNotification.Name(rawValue: "selectedServiceName"), object: nil)
        self.applyDesigns()
        self.applyFinishingTouchesToUIElements()
        let myTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tableView.isUserInteractionEnabled = true
        tableView.tableFooterView?.addGestureRecognizer(myTap)
        tableView.delaysContentTouches = false
        view.isUserInteractionEnabled = true
    }


    @objc func openSideMenu(n: Notification) {
        print("Opened")
        SideMenuSubServicesTableViewController.selectedServiesArray.removeAll()
      SideMenuSubServicesTableViewController.selectedServiesImagesArray.removeAll()
        SideMenuSubServicesTableViewController.subcategoryList.removeAllObjects()
        if categoryId == 4 || SideMenuSubServicesTableViewController.firstCategoryId == 4{
            navigationItem.title = "Create Custom Job"
            let rightBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "custom jobs add"), style: .plain, target: self, action: #selector(didTappedRightBarButton(_:)))
            navigationItem.rightBarButtonItem = rightBarButton
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
    }

    @objc func getcategoryId(n: Notification) {
        print(n)
        if let getCategoryId = n.userInfo?["categoryId"] {
            categoryId = getCategoryId as? Int
            print(getCategoryId)
        }
        if categoryId == 4 {
            navigationItem.title = "Create Custom Job"
            let rightBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "custom jobs add"), style: .plain, target: self, action: #selector(didTappedRightBarButton(_:)))
            navigationItem.rightBarButtonItem = rightBarButton
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
        else {
            self.hideNavigationButton()
        }
        SideMenuSubServicesTableViewController.selectedServiesArray.removeAll()
        SideMenuSubServicesTableViewController.selectedServiesImagesArray.removeAll()
        SideMenuSubServicesTableViewController.subcategoryList.removeAllObjects()
        self.callingSubServicesAPI()

    }

    @objc func getSelectedServiceName(n: Notification) {
        if let serviceName = n.userInfo?["serviceName"] {
            print("selectedService----------------\(serviceName)")
            getSelectedService = serviceName as? String
            navigationItem.title = getSelectedService
            SideMenuSubServicesTableViewController.selectedServicesTitle = getSelectedService
        }
    }

    func hideNavigationButton() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
       print("helo")

    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(openSideMenu(n:)), name: Notification.Name("openSideMenuOption"), object: nil)

        SideMenuSubServicesTableViewController.selectedServiesArray.removeAll()
        SideMenuSubServicesTableViewController.selectedServiesImagesArray.removeAll()
        SideMenuSubServicesTableViewController.subcategoryList.removeAllObjects()

        navigationController?.navigationBar.backgroundColor = .black
        tableView.alwaysBounceVertical = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        if  SideMenuSubServicesTableViewController.firstCategoryId == 4 {
            navigationItem.title = "Create Custom Job"
            let rightBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "custom jobs add"), style: .plain, target: self, action: #selector(didTappedRightBarButton(_:)))
            navigationItem.rightBarButtonItem = rightBarButton
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
        else {
            self.hideNavigationButton()
        }
    //    CheckTimeFunc()

    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseSubServicesTableViewCell") as! ChooseSubServicesTableViewCell

//        if categoryId == 4 {
//            if indexPath.row == 0 {
//                let cell2 = tableView.dequeueReusableCell(withIdentifier: "AddCustomlTableViewCell", for: indexPath) as! AddCustomlTableViewCell
//                cell2.addButton.addTarget(self, action: #selector(addButtonAction(_:)), for: .touchUpInside)
//
//                return cell2
//            }
//
//        }

        cell.nameLable.text = arrayData[indexPath.row].subcategoryName
        cell.selectionDeselectionButton.tag = indexPath.row
        cell.selectionDeselectionButton.addTarget(self, action: #selector(selectDeselectbutton(_:)), for: .touchUpInside)
        let url = URL(string: arrayData[indexPath.row].subcategoryImage ?? "")
        cell.serviceImage.sd_imageIndicator = SDWebImageActivityIndicator.gray//"Lawn Mowing"
        cell.serviceImage.sd_setImage(with: url, placeholderImage: UIImage(named: "Lawn Mowing"))


        return cell
    }


    @objc func addButtonAction(_ sender: UIButton) {
        navigate(.addCustomCategory)

    }

    // MARK: - Table View delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryId = UserStoreSingleton.shared.categoryId
        if categoryId == 4 {
            print("hi")
                let cell = tableView.cellForRow(at: indexPath) as! ChooseSubServicesTableViewCell
                cell.selectionDeselectionButton.isSelected.toggle()
                let indexPath = tableView.indexPathsForSelectedRows?.first
                let data = tableView.cellForRow(at: indexPath!) as? ChooseSubServicesTableViewCell
                let subcategoryId = arrayData[indexPath!.row].subcategoryId
                let subcategoryName = arrayData[indexPath!.row].subcategoryName
                let subcategoryImage = arrayData[indexPath!.row].subcategoryImage
                let dic = NSMutableDictionary()
                dic.setValue(String(subcategoryId!), forKey: "id")
                dic.setValue(subcategoryName, forKey: "name")
                dic.setValue(subcategoryImage, forKey: "image")
    //            SideMenuSubServicesTableViewController.subcategoryList.add(dic)
                if SideMenuSubServicesTableViewController.subcategoryList.contains(dic) {
                    let indexPathForSubcategory = SideMenuSubServicesTableViewController.subcategoryList.index(of: dic)
                    SideMenuSubServicesTableViewController.subcategoryList.removeObject(at: indexPathForSubcategory)
                }
                else {
                    SideMenuSubServicesTableViewController.subcategoryList.add(dic)
                }
                let bh = data?.nameLable.text ?? ""
                let image = data?.serviceImage.image
                if SideMenuSubServicesTableViewController.selectedServiesArray.contains(bh) {
                    let indexPathOfSelectedData = SideMenuSubServicesTableViewController.selectedServiesArray.firstIndex(of: bh)
                    SideMenuSubServicesTableViewController.selectedServiesArray.remove(at: indexPathOfSelectedData!)

                }
                else {
                    SideMenuSubServicesTableViewController.selectedServiesArray.append(bh)
                   SideMenuSubServicesTableViewController.selectedServiesImagesArray.append(image!)
              }

            }

        else {
            let cell = tableView.cellForRow(at: indexPath) as! ChooseSubServicesTableViewCell
            cell.selectionDeselectionButton.isSelected.toggle()
            let indexPath = tableView.indexPathsForSelectedRows?.first
            let data = tableView.cellForRow(at: indexPath!) as? ChooseSubServicesTableViewCell
            let subcategoryId = arrayData[indexPath!.row].subcategoryId
            let subcategoryName = arrayData[indexPath!.row].subcategoryName
            let subcategoryImage = arrayData[indexPath!.row].subcategoryImage
            let dic = NSMutableDictionary()
            dic.setValue(String(subcategoryId!), forKey: "id")
            dic.setValue(subcategoryName, forKey: "name")
            dic.setValue(subcategoryImage, forKey: "image")
//            SideMenuSubServicesTableViewController.subcategoryList.add(dic)
            if SideMenuSubServicesTableViewController.subcategoryList.contains(dic) {
                let indexPathForSubcategory = SideMenuSubServicesTableViewController.subcategoryList.index(of: dic)
                SideMenuSubServicesTableViewController.subcategoryList.removeObject(at: indexPathForSubcategory)
            }
            else {
                SideMenuSubServicesTableViewController.subcategoryList.add(dic)
            }
            let bh = data?.nameLable.text ?? ""
            let image = data?.serviceImage.image
            if SideMenuSubServicesTableViewController.selectedServiesArray.contains(bh) {
                let indexPathOfSelectedData = SideMenuSubServicesTableViewController.selectedServiesArray.firstIndex(of: bh)
                SideMenuSubServicesTableViewController.selectedServiesArray.remove(at: indexPathOfSelectedData!)

            }
//            if SideMenuSubServicesTableViewController.selectedServiesImagesArray.contains(image!) {
//                let indexPathOfSelectedData = SideMenuSubServicesTableViewController.selectedServiesArray.firstIndex(of: bh)
////                SideMenuSubServicesTableViewController.selectedServiesImagesArray.remove(at: indexPathOfSelectedData!)
//
//            }
            else {
                SideMenuSubServicesTableViewController.selectedServiesArray.append(bh)
               SideMenuSubServicesTableViewController.selectedServiesImagesArray.append(image!)
          }

        }
  }


    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0
    }


    @objc func didTappedRightBarButton(_ sender: UIBarButtonItem) {
        navigate(.addCustomCategory)
    }

//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        var footerView: UIView?
//        footerView = UIView(frame: CGRect(x: 50, y: 50, width: tableView.frame.size.width, height: 100))
//        footerView?.frame = CGRect(x: 0, y: 50, width: 100, height: 100)
//        footerView?.backgroundColor = UIColor(hexString: "#2B3038")
//        nextButton.frame = CGRect(x: (footerView!.frame.size.width)/2-50, y: (footerView!.frame.size.height) + 50, width: 120, height: 45)
//        nextButton.addTarget(self, action: #selector(selectionMethod), for: .touchUpInside)
//        footerView?.isUserInteractionEnabled = true
//        footerView?.addSubview(nextButton)
//        nextButton.bottomAnchor.constraint(equalTo: footerView!.bottomAnchor, constant: 250).isActive = true
//        nextButton.centerXAnchor.constraint(equalTo: footerView!.centerXAnchor).isActive = true
//        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        nextButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
//
//        return footerView
//    }


    // MARK: - Interface Builder Actions
    @objc func selectionMethod(_ sender: UIButton) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callBack"), object: nil)
        if SideMenuSubServicesTableViewController.selectedServiesArray.isEmpty == true {
            openAlert(title: "Alert", message: "Please select any Sub Category", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                print("Okay")
            }])
        }
        else {
            navigate(.uploadProfilePicture)
        }
    }

    @objc func selectDeselectbutton(_ sender: UIButton) {
        sender.isSelected.toggle()
        selectedIndexPathForSelectedData = IndexPath(item: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: selectedIndexPathForSelectedData!) as! ChooseSubServicesTableViewCell
        let subcategoryId = arrayData[sender.tag].subcategoryId
        let subcategoryName = arrayData[sender.tag].subcategoryName
        let dic = NSMutableDictionary()
        dic.setValue(String(subcategoryId!), forKey: "id")
        dic.setValue(subcategoryName, forKey: "name")
//        SideMenuSubServicesTableViewController.subcategoryList.add(dic)
        if SideMenuSubServicesTableViewController.subcategoryList.contains(dic) {
            let indexPathForSubcategory = SideMenuSubServicesTableViewController.subcategoryList.index(of: dic)
            SideMenuSubServicesTableViewController.subcategoryList.removeObject(at: indexPathForSubcategory)
        }
        else {
            SideMenuSubServicesTableViewController.subcategoryList.add(dic)
        }
        print(cell.nameLable.text ?? "")

        if SideMenuSubServicesTableViewController.selectedServiesArray.contains(cell.nameLable.text!) {
            let indexPathOfSelectedData = SideMenuSubServicesTableViewController.selectedServiesArray.firstIndex(of: cell.nameLable.text!)
            SideMenuSubServicesTableViewController.selectedServiesArray.remove(at: indexPathOfSelectedData!)
            SideMenuSubServicesTableViewController.selectedServiesImagesArray.remove(at: indexPathOfSelectedData!)

        }
        else {
            SideMenuSubServicesTableViewController.selectedServiesArray.append(cell.nameLable.text!)
            SideMenuSubServicesTableViewController.selectedServiesImagesArray.append(cell.serviceImage.image!)

        }

    }


    // MARK: - Helpers
    private func applyFinishingTouchesToUIElements() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ChooseSubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "ChooseSubServicesTableViewCell")
        
        tableView.register(UINib(nibName: "AddCustomlTableViewCell", bundle: nil), forCellReuseIdentifier: "AddCustomlTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.keyboardDismissMode = .onDrag
        SideMenuSubServicesTableViewController.selectedServiesArray.removeAll()
        if getSelectedService == nil {
            navigationItem.title = SideMenuSubServicesTableViewController.firstTimeSelectedService
            SideMenuSubServicesTableViewController.selectedServicesTitle = SideMenuSubServicesTableViewController.firstTimeSelectedService
        }
        else {
            navigationItem.title = getSelectedService
            SideMenuSubServicesTableViewController.selectedServicesTitle = getSelectedService
        }
  }


    private func applyDesigns() {
        SideMenuSubServicesTableViewController.selectedServiesArray.removeAll()

        view.backgroundColor = UIColor(hexString: "#2B3038")
        tableView.backgroundColor = UIColor(hexString: "#2B3038")
        tabBarController?.tabBar.isHidden = true
        storeArray = arrayData as NSArray
        print(storeArray)
        nextButton.backgroundColor = UIColor(hexString: "#20242A")
        nextButton.setTitle("NEXT", for: UIControl.State.normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.isUserInteractionEnabled = true
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        nextButton.isEnabled = true
        nextButton.addTarget(self, action: #selector(selectionMethod(_:)), for: .touchUpInside)
        view.isUserInteractionEnabled = true
        tableView.isUserInteractionEnabled = true
        navigationController?.view.addSubview(nextButton)
//      tableView.addSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: (navigationController?.view.centerXAnchor)!).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: navigationController!.view.bottomAnchor, constant: -20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.callingSubServicesAPI()
    }


    private func callingSubServicesAPI()  {
        self.showActivity()
        let Url = String(format: "http://3.18.59.239:3000/api/v1/sub-categories-list")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary =  ["categoryId": categoryId ?? SideMenuSubServicesTableViewController.firstCategoryId!] as [String: Any]
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
                    self.arrayData.removeAll()
                    self.hideActivity()
                    for arr in result.arrayValue {
                        self.arrayData.append(SubCatgeoryModel(json: arr))
                    }
                    DispatchQueue.main.async {
                        self.hideActivity()
                        self.nextButton.isHidden = false
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)

            }
        }.resume()
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

    func showActivity() {
        let activityData = ActivityData(size: CGSize(width: 30, height: 30), type: .circleStrokeSpin, color: .white, backgroundColor: UIColor(named: "AppColor"))
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }

    func hideActivity() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }

}
