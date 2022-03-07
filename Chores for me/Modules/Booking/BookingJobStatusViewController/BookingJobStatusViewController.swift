//
//  BookingJobStatusViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 23/04/21.
//

import UIKit
import Designable
import Cosmos
import SwiftyJSON

struct Properties {
    var jobProgessName: String
    var jobProgeressImageName: String
    var dateName: String
}

class BookingJobStatusViewController: BaseViewController {


    // MARK: - Outlets
    @IBOutlet weak var btn_Confirm: UIButton!
    @IBOutlet weak var view_StartComplete: UIView!
    @IBOutlet weak var view_CancelConfirm: UIView!
    @IBOutlet weak var btn_Call: UIButton!
    @IBOutlet weak var btn_CancelRequest: DesignableButton!
    @IBOutlet weak var img_ServiceImage: UIImageView!
    @IBOutlet weak var lbl_ServiceName: UILabel!
    @IBOutlet weak var lbl_ServiceAddres: UILabel!
    @IBOutlet weak var lbl_ServiceDay: UILabel!
    @IBOutlet weak var lbl_ServiceAmmount: UILabel!
    @IBOutlet weak var lbl_DateTime: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak private var servicesCollectioView: UICollectionView!
    @IBOutlet weak private var progressStatusCollectioView: UICollectionView!
    @IBOutlet weak private var starRating: CosmosView!
    @IBOutlet weak private var cancelButton: UIButton!


    // MARK: - Properties
    var jobId: Int?
    private var dataOfServicesCollectionView: [Properties] = []
    private var getJobsDetails: [JobDetailsData] = []
    var arrayOfJobProgress: [String] = []
    var dicData: JobHistoryData!
    var selectedStatus = Int()
    var subcategoryId = [JobsSubcategoryId]()
    fileprivate let application = UIApplication.shared
    var myJobDetails: JobDetailsdata!


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.isHidden = true
        starRating.settings.updateOnTouch = false
        starRating.rating = dicData.providerDetails?.rating ?? 0
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "Job Status"
        if let flowLayout = servicesCollectioView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        servicesCollectioView.delegate = self
        servicesCollectioView.dataSource = self
        servicesCollectioView.register(UINib(nibName: "BookingRequestServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookingRequestServiceCollectionViewCell")
        progressStatusCollectioView.delegate = self
        progressStatusCollectioView.dataSource = self
        progressStatusCollectioView.register(UINib(nibName: "JobStatusCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "JobStatusCollectionViewCell")

        let jobStatus = dicData.jobStatus

        switch jobStatus {
        case JobStatus.JOB_REQUEST:
            selectedStatus = 0
        case JobStatus.JOB_ACCEPT:
            selectedStatus = 1
        case JobStatus.JOB_PROGRESS:
            selectedStatus = 2
        case JobStatus.JOB_COMPLETED:
            selectedStatus = 3
        case JobStatus.JOB_REJECT, JobStatus.JOB_CANCELLED:
            selectedStatus = 4
        default:
            break
        }

        arrayOfJobProgress.append("Job progress")
        arrayOfJobProgress.append("Accepted")
        arrayOfJobProgress.append("work started")
        arrayOfJobProgress.append("Completed")
        if selectedStatus == 4 {
            arrayOfJobProgress.removeAll()
            arrayOfJobProgress.append("Job progress")
            arrayOfJobProgress.append("Cancelled")
        }

        let imageUrl = URL(string: dicData.providerDetails?.image ?? "")
        profileImageView.sd_setImage(with: imageUrl, placeholderImage:UIImage(contentsOfFile:"user.profile.icon.png"))
        nameLabel.text = dicData.providerDetails?.first_name
        locationLabel.text = dicData.location
        discriptionLabel.text = dicData.description
        subcategoryId = dicData.subcategoryId ?? [JobsSubcategoryId]()
        lbl_ServiceAddres.text = dicData.location
        lbl_ServiceName.text = dicData.categoryName


        let datenDay = dicData.day
        let dateDay = datenDay?.filter{!$0.isWhitespace}
        let result4 = String(dateDay?.dropFirst(2) ?? "")
        lbl_ServiceDay.text = result4

        lbl_ServiceAmmount.text = dicData.price
        let date = getDate(date: dicData.booking_date!)
        lbl_DateTime.text = dicData.time! + " : " + date!

        let imageUrlService = URL(string: dicData.image ?? "")
        img_ServiceImage.sd_setImage(with: imageUrlService, placeholderImage:UIImage(contentsOfFile:"user.profile.icon.png"))
        self.callingGetUserDetailsAPI()
        let rating = dicData.providerDetails?.rating ?? 0.0
        if selectedStatus == 0 {
            btn_Call.isHidden = true
        }
        if selectedStatus == 1 {
            cancelButton.isHidden = false
        }
        if selectedStatus == 2 {
        }
        if selectedStatus == 3 || selectedStatus == 4 {
            btn_Call.isHidden = true
        }
      }

    override func viewWillAppear(_ animated: Bool) {
        self.callingGetUserDetailsAPI()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.callingGetUserDetailsAPI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - User Interaction
    @IBAction func tapCancellRequestButton(_ sender: Any) {
        navigate(.cancelJobRequest)
    }

    @IBAction func cancelJobButtonAction(_ sender: UIButton) {

        self.callingCancelJobByCustomerAPI()

    }

    @IBAction func didTappdCallButton(_ sender: UIButton) {
        let phone = "tel://\(UserStoreSingleton.shared.DialCode ?? "+91")\(dicData.providerDetails?.phone ?? "0123456789")"
        print(phone)

        if let phoneUrl = URL(string: "tel://\(dicData.providerDetails?.phone ?? "0123456789")") {
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


    // MARK: - Additional Helpers
    private func updateDataSaucre() {
        dataOfServicesCollectionView.append(Properties(jobProgessName: "Job Progress", jobProgeressImageName: "job progress", dateName: "13:30 02/Feb/2021"))
        dataOfServicesCollectionView.append(Properties(jobProgessName: "Accepted", jobProgeressImageName: "accepted", dateName: "13:30 02/Feb/2021"))
        dataOfServicesCollectionView.append(Properties(jobProgessName: "Work Started", jobProgeressImageName: "deselectedButton", dateName: ""))
        dataOfServicesCollectionView.append(Properties(jobProgessName: "completed", jobProgeressImageName: "deselectedButton", dateName: ""))

    }

    private func callingGetUserDetailsAPI() {
        let jobId = dicData.jobId
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-jobDetails/\(jobId ?? 218)")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    let json =  try JSONDecoder().decode(JobDetailsModel.self, from: data ?? Data())
                   
                    DispatchQueue.main.async {
                        print(json)
                        debugPrint(json)
                          print(JobDetailsModel.self)
                            if let myData = json.data {
                                print(myData)
                                self.myJobDetails = json.data
                                self.experienceLabel.text = self.myJobDetails.providerDetails?.work_exp
                            }
                    }
                } catch {
                    print(error)
                }

            }
                task.resume()
         }



    func StatusChange(cell: JobStatusCollectionViewCell,indexSelected: Int, isGreenLeft: Bool, isGreenRight: BooleanLiteralType) {
        cell.jobProgressImageView.image = UIImage.init(named: "circle.empty")
        cell.jobProgressImageView.tintColor = UIColor.systemOrange

        if selectedStatus >= indexSelected {

            cell.jobProgressImageView.image = UIImage.init(named: "checked")
            cell.jobProgressImageView.tintColor = UIColor.systemOrange

            if selectedStatus == indexSelected {
                cell.jobProgressImageView.image = UIImage.init(named: "checked")
                cell.jobProgressImageView.tintColor = UIColor.systemGreen
            }
            if isGreenRight {
                cell.rightBarView.backgroundColor = UIColor.systemGreen
            }
            if isGreenLeft {
                cell.leftBarView.backgroundColor = UIColor.systemGreen
            }
        }
        else {
            cell.jobProgressImageView.tintColor = UIColor.systemGray
        }
   }


    private func callingCancelJobByCustomerAPI() {
        let Url = String(format: "http://3.18.59.239:3000/api/v1/cancel-Job-By-Customer")
        guard let serviceUrl = URL(string: Url) else { return }
        canceljobId = dicData.jobId
        let parameterDictionary =  ["jobId": dicData.jobId ?? "","UserId": dicData.userId ?? "","providerId": dicData.providerId ?? 0] as [String: Any]

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
                    let json = try JSONDecoder().decode(CancelJobByCustomer.self, from: data)
                    print(json)
                    DispatchQueue.main.async {
                        let responseMessage = json.data?.minutes
                        if json.data?.minutes ?? 0 < 5 {
                            RootRouter().loadMainHomeStructure()
                        }else{
                            let dialogMessage = UIAlertController(title: "Chores for me", message: "Are you sure? you want to Cancel this job", preferredStyle: .alert)
                            let delete = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) -> Void in
                                print("Delete button tapped")
                                self.navigate(.cancelPayment)
                          })

                            let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
                                print("Cancel button tapped")
                            }

                            dialogMessage.addAction(delete)
                            dialogMessage.addAction(cancel)
                            self.present(dialogMessage, animated: true, completion: nil)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}




// MARK: - UICollectionViewDelegate
extension BookingJobStatusViewController: UICollectionViewDelegate {

}


// MARK: - UICollectionViewDataSource
extension BookingJobStatusViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == progressStatusCollectioView {
            return arrayOfJobProgress.count
        }
        return subcategoryId.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == progressStatusCollectioView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobStatusCollectionViewCell", for: indexPath) as? JobStatusCollectionViewCell
            else {
                fatalError()
            }
            var isPrevious = false
            cell.jobProgressImageView.tintColor = UIColor.systemGray

            if indexPath.item == 0 {
                cell.leftBarView.isHidden = true
                if selectedStatus >= 1 {
                    isPrevious = true
                }
                StatusChange(cell: cell, indexSelected: indexPath.item, isGreenLeft: false, isGreenRight: isPrevious)
            }

            if indexPath.item == 1 {
                if selectedStatus >= 2 {
                    isPrevious = true
                }

                StatusChange(cell: cell, indexSelected: indexPath.item, isGreenLeft: true, isGreenRight: isPrevious)
            }

            if indexPath.item == 2 {
                if selectedStatus >= 3 {
                    isPrevious = true
                }
                StatusChange(cell: cell, indexSelected: indexPath.item, isGreenLeft: true, isGreenRight: isPrevious)

            }

            if indexPath.item == 3 {
                cell.rightBarView.isHidden = true
                StatusChange(cell: cell, indexSelected: indexPath.item, isGreenLeft: true, isGreenRight: false)
            }

            if selectedStatus == 4 {
                cell.jobProgressLabel.textColor = .red
                cell.jobProgressImageView.tintColor = UIColor.green
                cell.rightBarView.backgroundColor = UIColor.systemGreen
                cell.leftBarView.backgroundColor = UIColor.systemGreen
                if indexPath.row == 1 {
                    cell.rightBarView.isHidden = true
                    cell.jobProgressImageView.image = UIImage.init(named: "icon-3")
                    cell.jobProgressImageView.tintColor = UIColor.red
                    cell.jobProgressImageView.layer.cornerRadius = 0
                }
            }

            cell.jobProgressLabel.text = arrayOfJobProgress[indexPath.row]
            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingRequestServiceCollectionViewCell", for: indexPath) as? BookingRequestServiceCollectionViewCell else {
            fatalError()
        }
        cell.selectedServiceName.text = subcategoryId[indexPath.row].name

        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension BookingJobStatusViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == progressStatusCollectioView {
            return 0
        }
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == progressStatusCollectioView {
            return 0
        }
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == progressStatusCollectioView {
            if selectedStatus == 4 {
                return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
            }
            return CGSize(width: 100, height: collectionView.frame.height)
        }
        return CGSize(width: 100, height: collectionView.frame.height)
    }


    func getDate(date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //    dateFormatter.timeZone = TimeZone.current
        //    dateFormatter.locale = Locale.current
        let dateValue = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: dateValue)
    }
}
