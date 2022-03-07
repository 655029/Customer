//
//  BookingHistoryViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 24/04/21.
//

import UIKit
import Designable
import SDWebImage

class BookingHistoryViewController: HomeBaseViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var loctionButton: DesignableButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noJobsImageView: UIImageView!
    @IBOutlet weak var noJobsLabel: UILabel!

    
    // MARK: - Properties
    var bookingHistoryResponseData:[JobHistoryData] = []
    var myJobDetails: JobDetailsdata!
    var getJobId: Int?


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loctionButton.addSpaceBetweenImageAndTitle(spacing: 10.0)
        navigationItem.title = "Hello \(UserStoreSingleton.shared.name ?? "")";
      //  navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.red]

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "BookingsHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingsHistoryTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
        self.loctionButton.setTitle(UserStoreSingleton.shared.Address, for: .normal)
        tabBarController?.tabBar.isHidden = false
        self.callingJobsHistoryApi()

    }
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    // MARK: - Additional Helpers

    func callingJobsHistoryApi() {
        showActivity()
        let parameters = ["signupType":"0"]
             let url = URL(string: "http://3.18.59.239:3000/api/v1/jobs-history")
             var request = URLRequest(url: url!)
             request.httpMethod = "POST"
             request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
             //  print("Token is",UserStoreSingleton.shared.Token)
             request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
             guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                 return
             }
             request.httpBody = httpBody
        self.hideActivity()
             let session = URLSession.shared
             session.dataTask(with: request) { (data, response, error) in
                 if let Apiresponse = response {
                     debugPrint(Apiresponse)
                 }
                 if let data = data {
                     do {
                         let json =  try JSONDecoder().decode(JobsHistoryModel.self, from: data)
                        self.hideActivity()
                         DispatchQueue.main.async {
                             if json.data?.count == 0 {
                                 self.showMessage(json.message ?? "")
                                 self.bookingHistoryResponseData = []
                                self.tableView.isHidden = true
                                self.noJobsImageView.isHidden = false
                                self.noJobsLabel.isHidden = false
                             } else{
                                if let myData = json.data {
                                    self.tableView.backgroundView = nil
                                    print(myData)
                                     self.bookingHistoryResponseData = myData
                                    self.showMessage(json.message ?? "")
                                    self.tableView.isHidden = false
                                    self.noJobsImageView.isHidden = true
                                    self.noJobsLabel.isHidden = true
                                     self.tableView.reloadData()
                                }
                             }
                         }
                     }catch{
                        print("\(error.localizedDescription)")
                        self.hideActivity()
                     }
                 }
             }.resume()
    }

    private func callingGetProviderDetailsAPI() {
            let jobId = getJobId
            var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-jobDetails/\(jobId ?? 218)")!,timeoutInterval: Double.infinity)
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

    func getDate(date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //    dateFormatter.timeZone = TimeZone.current
        //    dateFormatter.locale = Locale.current
        let dateValue = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: dateValue)
    }

    
}

// MARK: - UITableViewDelegate

extension BookingHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data = bookingHistoryResponseData[indexPath.row]
        getJobId = data.jobId
        self.callingGetProviderDetailsAPI()
               let storyborad = UIStoryboard(name: "Booking", bundle: nil)
               let secondVc = storyborad.instantiateViewController(withIdentifier: "BookingJobStatusViewController") as! BookingJobStatusViewController
               secondVc.dicData = data
               navigationController?.pushViewController(secondVc, animated: true)

    }
}

// MARK: - UITableViewDataSource

extension BookingHistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingHistoryResponseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingsHistoryTableViewCell") as? BookingsHistoryTableViewCell else {
            return UITableViewCell()
        }
        print("Items",bookingHistoryResponseData[indexPath.row].jobStatus)
        if bookingHistoryResponseData[indexPath.row].jobStatus?.lowercased() == "cancel"{
            cell.cancelLabel.isHidden = false
            cell.checkButton.isHidden = true
        }else if bookingHistoryResponseData[indexPath.row].jobStatus?.lowercased() == "complete" {
            cell.cancelLabel.isHidden = true
            cell.checkButton.isHidden = false

        }
        let imageUrl = URL(string: "\(bookingHistoryResponseData[indexPath.row].providerDetails?.image ?? "")")
        let providerImageUrl = URL(string: bookingHistoryResponseData[indexPath.row].image ?? "")
        print(providerImageUrl)
        cell.categoryImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.categoryImage.sd_setImage(with: providerImageUrl, placeholderImage:UIImage(contentsOfFile:"Lawn Mowing"))
        cell.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.profileImage.sd_setImage(with: imageUrl, placeholderImage:UIImage(contentsOfFile:"outdoor_home_service.png"))
        cell.categoryname.text = bookingHistoryResponseData[indexPath.row].categoryName
        cell.locationName.text = bookingHistoryResponseData[indexPath.row].location

        var selectedDay = bookingHistoryResponseData[indexPath.row].day
        let dateDay = selectedDay?.filter{!$0.isWhitespace}
        let result4 = String(dateDay?.dropFirst(2) ?? "")
        cell.selectedDay.text = result4
//        let index = (selectedDay!.range(of: "\n ")?.upperBound)
//        let afterEqualsTo = String(selectedDay!.suffix(from: index!))
        selectedDay = selectedDay!.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range: nil)

       // let dayWithOutDate = String((selectedDay?.dropFirst(3))!)

        cell.selectedDate.text = bookingHistoryResponseData[indexPath.row].time
        cell.selectedPrice.text = bookingHistoryResponseData[indexPath.row].price
        cell.starRating.rating = bookingHistoryResponseData[indexPath.row].providerDetails?.rating ?? 0
        let dateTime = getDate(date: bookingHistoryResponseData[indexPath.row].booking_date ?? "")
       // let date = String(dateTime?.dropLast(14) ?? "")
        cell.dateCreatedAt.text = dateTime
        cell.userName.text = bookingHistoryResponseData[indexPath.row].providerDetails?.first_name
        let arr = bookingHistoryResponseData[indexPath.row].subcategoryId
        cell.arrSubCatgeory = arr ?? []
        cell.copyIconButton.tag = indexPath.row
        cell.copyIconButton.addTarget(self, action: #selector(didTappedCopyIconButton(_:)), for: .touchUpInside)

        return cell
    }

    @objc func didTappedCopyIconButton(_ sender: UIButton) {
        let location = bookingHistoryResponseData[sender.tag].location
        UIPasteboard.general.string = location
        showMessage("Copied")
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
  }

