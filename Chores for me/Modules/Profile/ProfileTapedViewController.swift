//
//  ProfileTapedViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 16/07/21.
//

import UIKit
import Designable
import Cosmos
import SDWebImage

protocol AlertTypeDelegate {
    func successDelegate()
}

struct DataStruct {
    var imageName: String
    var labelName: String
}

class ProfileTapedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DissmissConfirmationViewController {
    func didTapAgreeButton(controller: ConfirmationViewController) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PaymentModeViewController") as? PaymentModeViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }


    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var providerImage: UIImageView!
    @IBOutlet weak private var providerName: UILabel!
    @IBOutlet weak private var providerExprience: UILabel!
    @IBOutlet weak private var providerLocation: UILabel!
    @IBOutlet weak private var providerDescription: UILabel!
    @IBOutlet weak private var servicesCollectionView: UICollectionView!
    @IBOutlet weak private var hireButton: UIButton!
    @IBOutlet weak private var sunDayButton: UIButton!
    @IBOutlet weak private var monDayButton: UIButton!
    @IBOutlet weak private var tueDayButton: UIButton!
    @IBOutlet weak private var wedDayButton: UIButton!
    @IBOutlet weak private var thuDayButtton: UIButton!
    @IBOutlet weak private var friDayButtton: UIButton!
    @IBOutlet weak private var satDayButtton: UIButton!
    @IBOutlet weak private var callButton: DesignableButton!
    @IBOutlet weak private var firstTimeButton: DesignableButton!
    @IBOutlet weak private var secondTimeButton: DesignableButton!
    @IBOutlet weak var starRating: CosmosView!


    //MARK: - Properties
    var dicData: ProviderListModel!
    var subCategoryImageArray = [String]()
    var subcategoryData = [String]()
    var subcategoryPriceData = [String]()
    var selectedTime = [String]()
    var selectedDays = [String]()
    fileprivate let application = UIApplication.shared
    

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        let photoUrl = URL(string: self.dicData.image ?? "")
        if photoUrl ==  nil{
        }else{
            self.providerImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.providerImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(contentsOfFile: "upload profile picture.png"))
        }
        navigationController?.navigationBar.isHidden = false

        providerName.text = dicData.first_name
        providerExprience.text = dicData.work_exp
        providerLocation.text = dicData.location_address
        providerDescription.text = dicData.exp_desciption
        selectedDays = (dicData.availability_provider_days?.components(separatedBy: ","))!
        selectedTime = (dicData.availability_provider_timing?.components(separatedBy: ","))!
        starRating.rating = dicData.rating ?? 0

        let dayButtons = [sunDayButton,monDayButton,tueDayButton,wedDayButton,thuDayButtton,friDayButtton,satDayButtton]
        for item in dayButtons {
            item?.layer.borderWidth = 0.5
            item?.layer.borderColor = UIColor.lightGray.cgColor
            for i in selectedDays {
                if let index = (i.range(of: "\n ")?.upperBound)
                {
                  //prints "value"
                  let afterEqualsTo = String(i.suffix(from: index))
                    if item?.titleLabel?.text == afterEqualsTo {
                        item?.backgroundColor = .white
                        let buttonTextcolor = UIColor.black
                        item?.titleLabel?.textColor = buttonTextcolor
                        item?.setTitleColor(.black, for: .normal)
                        item?.setTitleColor(buttonTextcolor, for: .normal)
                        item?.titleLabel?.textColor = item?.titleLabel?.textColor ?? UIColor.black
                        item?.tintColor = .black
                        item?.titleLabel?.tintColor = .black
                        item?.titleLabel?.textColor = .red
                    }
                }
                else {
                    let freedSpaceString = i.filter {!$0.isWhitespace}
                    if item?.titleLabel?.text == freedSpaceString {
                        item?.backgroundColor = .white
                        item?.titleLabel?.textColor = AppColor.primaryBackgroundColor
                        let buttonTextcolor = UIColor.black
                        item?.titleLabel?.textColor = buttonTextcolor
                        item?.setTitleColor(.black, for: .normal)
                        item?.setTitleColor(buttonTextcolor, for: .normal)
                        item?.titleLabel?.textColor = item?.titleLabel?.textColor ?? UIColor.black
                        item?.tintColor = .black
                        item?.titleLabel?.tintColor = .black
                        item?.titleLabel?.textColor = .red

                    }

                }

            }
        }
        selectedTime.append("")
        print(selectedTime[0])
        firstTimeButton.setTitle(selectedTime[0], for: .normal)
        starRating.settings.updateOnTouch = false
        self.applyFinishingTouchesToUIElements()
    }
    


    //MARK: - Helpers
    private func applyFinishingTouchesToUIElements() {
        providerExprience.layer.borderWidth = 1.0
        providerExprience.layer.borderColor = UIColor.blue.cgColor

//        servies.append(DataStruct(imageName: "outdoor_home_service", labelName: "Lawn Mowing[$50]"))
//        servies.append(DataStruct(imageName: "Picking Weeds", labelName: "Weed Removal[$50]"))
//        servies.append(DataStruct(imageName: "Planting", labelName: "Planting [$100]"))
        subCategoryImageArray.append("outdoor_home_service")
        subCategoryImageArray.append("Picking Weeds")
        subCategoryImageArray.append("Planting")
        subCategoryImageArray.append("Picking Weeds")
        subCategoryImageArray.append("outdoor_home_service")
        subCategoryImageArray.append("outdoor_home_service")
        subCategoryImageArray.append("Picking Weeds")
        subCategoryImageArray.append("Planting")
        subCategoryImageArray.append("Picking Weeds")
        subCategoryImageArray.append("outdoor_home_service")
        subCategoryImageArray.append("outdoor_home_service")
        subCategoryImageArray.append("Picking Weeds")
        subCategoryImageArray.append("Planting")
        subCategoryImageArray.append("Picking Weeds")
        subCategoryImageArray.append("outdoor_home_service")


        let nib = UINib(nibName: "ServicesCollectionViewCell", bundle: nil)
        servicesCollectionView.register(nib, forCellWithReuseIdentifier: "ServicesCollectionViewCell")

        let image = UIImage(named: "png8")?.withRenderingMode(.alwaysTemplate)
        hireButton.setImage(image, for: .normal)
        hireButton.tintColor = .white
        subcategoryData = (dicData.subcategoryName?.components(separatedBy: ","))!
        subcategoryPriceData = (dicData.subcategoryPrice?.components(separatedBy: ","))!

    }


    //MARK: - UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dicData.subcategoryName?.components(separatedBy: ",").count ?? 0

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = servicesCollectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCollectionViewCell", for: indexPath) as! ServicesCollectionViewCell
        cell.serviceName.text = subcategoryData[indexPath.row]
        cell.image.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.image.image = UIImage(named: subCategoryImageArray[indexPath.row])
        cell.servicePriceLabel.text = "[$\(subcategoryPriceData[indexPath.row])]"

        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 16
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 16
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {        return CGSize(width: 150, height: 100)
    }

    @IBAction func callButtonAction(_ sender: UIButton) {
        let phone = "tel://\(dicData.phone)"
        print(phone)

        if let phoneUrl = URL(string: "tel://\(dicData.phone ?? "0123456789")") {
            if application.canOpenURL(phoneUrl) {
                application.open(phoneUrl, options: [:], completionHandler: nil)
            }
            else {
                openAlert(title: "Alert", message: "you don,t have phone call access", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("ok")
                }])
            }
        }
    }


    @IBAction func hireButtonAction(_ sender: Any) {
        UserStoreSingleton.shared.totalPrice = dicData.subcategoryPrice
        callingUpdateJobAPI()
    }


    private func callingUpdateJobAPI(){
        let Url = String(format: "http://3.18.59.239:3000/api/v1/updatejob")
        guard let serviceUrl = URL(string: Url) else { return }

        let parameterDictionary =  ["jobId": UserStoreSingleton.shared.jobId ?? "","UserId":UserStoreSingleton.shared.userID ?? "","providerId":dicData.userId ?? "","jobStatus":"request"] as [String: Any]

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
                    let json = try JSONDecoder().decode(RegisterModel.self, from: data)
                    print(json)
                    DispatchQueue.main.async {
                        let responseMessage = json.status
                        if responseMessage == 200 {
                            RootRouter().loadMainHomeStructure()
                        }
                        else{
                          //  self.navigate(.paymentMode)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }


    private func callingGetUserProfileAPI() {
        let url = URL(string: "http://3.18.59.239:3000/api/v1/get-user-Profile")
                var request = URLRequest(url: url!)
                request.httpMethod = "GET"
                request.setValue("application/json", forHTTPHeaderField:"Content-Type")
                request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
                let session = URLSession.shared
               session.dataTask(with: request as URLRequest) { data, response, error in
                    if let data = data {
                        do {
                            let json =  try JSONDecoder().decode(SetUpProfile.self, from: data)
                            debugPrint(json)
                            //  print(GetUserProfile.self)
                            DispatchQueue.main.async {
                                print(json)
//                                self.nameLabel.text = json.data?.name
//                                self.gmailLabel.text = json.data?.email
//                                _ = json.data?.image
//                                let url = URL(string: (json.data?.image!)!)
//                                self.profileImage.sd_setImage(with: url, placeholderImage:UIImage(contentsOfFile:"placeholder.png"))
                            }
                        } catch {
                            print(error)
                        }
                    }
                }.resume()

    }
    

}
