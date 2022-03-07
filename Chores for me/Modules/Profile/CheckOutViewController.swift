//
//  CheckOutViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 16/07/21.
//

import UIKit
import Designable

class Property {
    var image: String
    var nameOfImage: String
    var isSelected: Bool

    init(image: String, nameOfImage: String, isSelected: Bool = false) {
        self.image = image
        self.nameOfImage = nameOfImage
        self.isSelected = isSelected
    }
}

protocol DissmissCheckoutViewController: class {
    func didTappedContinueButton(controller: CheckOutViewController)
}


class CheckOutViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {


    //MARK: - Properties
    var properties: [Property] = []
    var dicDataa:[JobHistoryData] = []
    var ratingData: NotificationData!
    var myJobDetails: JobDetailsdata!
    var someArr = [SubcategoryIdJobdetails]()
    var jobid: Int?
    var delegate: DissmissConfirmAlertViewontroller?


    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var selctedServicesCollectionView: UICollectionView!
    @IBOutlet weak private var paypalButton: DesignableButton!
    @IBOutlet weak private var googlePayButton: DesignableButton!
    @IBOutlet weak private var applePayButton: DesignableButton!
    @IBOutlet weak private var creditCardButton: DesignableButton!
    @IBOutlet weak private var paypalSelctedImage: UIImageView!
    @IBOutlet weak private var googlePaySelectedImage: UIImageView!
    @IBOutlet weak private var applePaySelectedImage: UIImageView!
    @IBOutlet weak private var creditCardSelectedImage: UIImageView!
    @IBOutlet weak private var selctedPriceLabel: UILabel!
    @IBOutlet weak private var proceedButton: UIButton!
    @IBOutlet weak private var backButton: UIButton!



    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.title = "Checkout"
        navigationController?.navigationBar.tintColor = .white
        selctedServicesCollectionView.dataSource = self
        selctedServicesCollectionView.delegate = self
        proceedButton.isEnabled = false
        self.applyFinishingTouchesToUIElements()

    }


    override func viewWillAppear(_ animated: Bool) {
        self.callingJobDetailsAPI()
        creditCardSelectedImage.image = UIImage(named: "unselectedButton")
        tabBarController?.tabBar.isHidden = true
        proceedButton.isEnabled = false
        navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backButtonImage = UIImage(named: "BACK")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = .white
    }


    //MARK: - UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return someArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selctedServicesCollectionViewCell", for: indexPath) as! selctedServicesCollectionViewCell
        cell.selectedServiceLabel.text = someArr[indexPath.row].name
        cell.layer.borderWidth = 2.0
        cell.layer.cornerRadius = 7
        cell.layer.borderColor = UIColor.gray.cgColor
        
        return cell
    }


    //MARK: - Helpers
    private func applyFinishingTouchesToUIElements() {
        let nib2 = UINib(nibName: "selctedServicesCollectionViewCell", bundle: nil)
        selctedServicesCollectionView.register(nib2, forCellWithReuseIdentifier: "selctedServicesCollectionViewCell")
    }

    private func setUpDataSource() {
        let dataSourceArray = [["name": "", "image": "PAYPAL"], ["name": "", "image": "G PAY"], ["name": "", "image": "APPLE PAY"],["name": "", "image": "CREDIT"]]
        for value in dataSourceArray {
            let name = value["name"] ?? ""
            let image = value["image"] ?? ""
            let property = Property(image: image, nameOfImage: name)
            properties.append(property)
        }
    }


    //MARK: - UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellHeight = collectionView.bounds.size.height - 10
        let cellWidth = collectionView.bounds.size.width - 30

        return CGSize(width: CGFloat(cellWidth), height: CGFloat(cellHeight))
    }


    //MARK: - Interface Builder Actions
    @IBAction func paypalButttonAction(_ sender: DesignableButton) {

    }
    @IBAction func btn_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func googlePayButtonAction(_ sender: DesignableButton) {

    }

    @IBAction func applePayButtonAction(_ sender: DesignableButton) {

    }

    @IBAction func creditCardButtonAction(_ sender: DesignableButton) {
        let imageSystem =  UIImage(named: "unselectedButton")
        if creditCardSelectedImage.image?.pngData() == imageSystem?.pngData() {
            creditCardSelectedImage.image = UIImage(named: "selectedButton")
            proceedButton.isEnabled = true
        }
        else {
            creditCardSelectedImage.image = UIImage(named: "unselectedButton")
        }

    }

    @IBAction func continueButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let paymentModeVc = storyboard.instantiateViewController(withIdentifier: "PaymentModeViewController") as! PaymentModeViewController
        paymentModeVc.jobid = jobid
        navigationController?.pushViewController(paymentModeVc, animated: true)
    }


    //MARK: - Additional Helpers
    private func callingJobDetailsAPI() {
        someArr.removeAll()
        jobid = UserStoreSingleton.shared.jobId
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-jobDetails/\(jobid ?? 0)")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(JobDetailsModel.self, from: data ?? Data())
                debugPrint(json)
                print(JobDetailsModel.self)
                DispatchQueue.main.async { [self] in
                    print(json)
                    if let myData = json.data {
                        print(myData)
                        self.myJobDetails = json.data
                        print(myJobDetails)
                        let valueSome = json.data?.subcategoryId
                        let getprice = json.data?.price
                        UserStoreSingleton.shared.totalPrice = getprice
                        let dollar = "$"
                        selctedPriceLabel.text =   getprice
                        print(valueSome)
                        someArr.append(contentsOf: valueSome ?? [])
                        print(someArr)
                        selctedServicesCollectionView.reloadData()
                    }
                }
            } catch {
                print(error)
            }

        }

        task.resume()
    }

}
