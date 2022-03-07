//
//  UpdateJobViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 26/11/21.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Toast_Swift

var selectJob_id: Int?
struct SelectedData1 {
    let image: String
    let name: String
}

class UpdateJobViewController: ServiceBaseViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,  UIImagePickerControllerDelegate, UINavigationControllerDelegate,LocationDelegate, UITextViewDelegate {

    func childViewControllerResponse(location: String) {
        print(location)
        locationLandmarkAddressTextFeild.text = location
    }


    // MARK: - Outlets
    @IBOutlet weak var topCollectionViewForSelectedServices: UICollectionView!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak private var mainTopView: UIView!
    @IBOutlet weak private var secondView: UIView!
    @IBOutlet weak private var thirdView: UIView!
    @IBOutlet weak private var descriptionTextView: UITextView!
    @IBOutlet weak private var firstCollectionView: UICollectionView!
    @IBOutlet weak private var dateTimecollectionView: UICollectionView!
    @IBOutlet weak private var cameraIconImage: UIImageView!
    @IBOutlet weak private var locationLandmarkAddressTextFeild: UITextField!
    @IBOutlet weak  var topLable: UILabel!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var priceTextFeild: UITextField!


    // MARK: - Properties
    var selectedDateIndex = Int()
    var service: Service!
    var selectedTimeIndex: Int?
    var selectedDate: String?
    var selectedTime: String?
    var arrayOfSelectedImages:[String] = []
    var arrayOfSelectedName:[String] = []
    var arrayOfSelectedServices:[SelectedData1] = []
    var filterArrayOfSelctedServicesName:[String] = []
    var labelName = String()
    var arrayForDateTimeCollectionView:[String] = []
    var useDateArray: [String] = []
    var emptyArray: [String] = []
    var dateArray = [Date]()
    var dateVal: String?
    var timeVal: String?
    var dayValue : Int = 0 {
        didSet{
            dateArray.append(Calendar.current.date(byAdding: .day, value: dayValue, to: Date()) ?? Date())
        }
    }
    var imagePicker = UIImagePickerController()
    var selectedIndexPath: IndexPath?
    let now = Date()
    let dateFormatter = DateFormatter()


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ChooseLocationFromMapViewController.delegate = self
//        if comeFrom == "EditPost" {
//            firstCollectionView.isUserInteractionEnabled = false
//            dateTimecollectionView.isUserInteractionEnabled = false
//
            getBookingDeatils()
//        }else{
//
//        }

        if SideMenuSubServicesTableViewController.selectedServicesTitle?.isEmpty == false {
            topLable.text = SideMenuSubServicesTableViewController.selectedServicesTitle
        }
        else {
            topLable.text = "Create \(AddCustomViewViewController.selectedServicesTitle ?? "")"
        }
        topLable.font = .boldSystemFont(ofSize: 22)
        descriptionTextView.delegate = self
        descriptionTextView.text = "Add Description"
        descriptionTextView.textColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.yellow
        if let flowlayout = topCollectionViewForSelectedServices.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        for i in 1...7 {
            self.dayValue = i
        }
        navigationController?.navigationBar.tintColor = .orange
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd EEEE"
        for item in dateArray {
            let dd =  dateFormatterGet.string(from: item )
            let date = dateFormatterGet.date(from: dd)
            print(dateFormatterPrint.string(from: date!))
            let stringFormatOfDate = dateFormatterPrint.string(from: date!)
            useDateArray.append(stringFormatOfDate)
        }
        dateFormatter.dateFormat = "LLLL yyyy"
        let nameOfMonth = dateFormatter.string(from: now)
        monthYearLabel.text = nameOfMonth
        self.imagePicker.delegate = self
        self.applyFinishingTouchesToUIElements()
    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
      //  locationLandmarkAddressTextFeild.text = ""
        priceTextFeild.text = ""
        descriptionTextView.text = ""
        dateVal = "0"
        timeVal = "0"
    }


    // MARK: - TextView Delegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Add Description"
            descriptionTextView.textColor = UIColor.lightGray
        }
    }


    // MARK: - User Interaction
    @IBAction func uploadSelfieButtonAction(_ sender: Any) {
        navigate(.uploadIDProof)
    }

    @IBAction func openMap(_ sender: Any) {
        navigate(.chooseLocationOnMap)
    }


    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)

    }


    //MARK: - ImagePicker Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        selectedImage = self.imageOrientation(selectedImage!)
        selectImage.image = selectedImage
        uploadImage(paramName: "photo", fileName: "png", image: selectedImage!)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTappedLocationLandmarkTextFeild(_ sender: UITapGestureRecognizer) {
        navigate(.chooseLocationOnMap)
    }


    // MARK: - Additional Helpers
    private func applyFinishingTouchesToUIElements() {
        tabBarController?.tabBar.isHidden = true
        firstCollectionView.allowsMultipleSelection = false
        dateTimecollectionView.allowsMultipleSelection = false
        let nib = UINib(nibName: "DateandTimeCollectionViewCell", bundle: nil)
        firstCollectionView.register(nib, forCellWithReuseIdentifier: "DateandTimeCollectionViewCell")
        let nib2 = UINib(nibName: "SecondCollectionViewCell", bundle: nil)
        dateTimecollectionView.register(nib2, forCellWithReuseIdentifier: "SecondCollectionViewCell")
        let nib3 = UINib(nibName: "SelectedCollectionViewCell", bundle: nil)
        topCollectionViewForSelectedServices.register(nib3, forCellWithReuseIdentifier: "SelectedCollectionViewCell")
        arrayForDateTimeCollectionView.append("07:00 am")
        arrayForDateTimeCollectionView.append("08:00 am")
        arrayForDateTimeCollectionView.append("09:00 am")
        arrayForDateTimeCollectionView.append("10:00 am")
        arrayForDateTimeCollectionView.append("11:00 am")
        arrayForDateTimeCollectionView.append("12:00 am")
        arrayForDateTimeCollectionView.append("01:00 pm")
        arrayForDateTimeCollectionView.append("02:00 pm")
        arrayForDateTimeCollectionView.append("03:00 pm")
        arrayForDateTimeCollectionView.append("04:00 pm")
        arrayForDateTimeCollectionView.append("05:00 pm")
        arrayForDateTimeCollectionView.append("06:00 pm")
        arrayForDateTimeCollectionView.append("07:00 pm")
        arrayForDateTimeCollectionView.append("08:00 pm")
        arrayForDateTimeCollectionView.append("09:00 pm")
        arrayForDateTimeCollectionView.append("10:00 pm")
        firstCollectionView.allowsMultipleSelection = false

        if let flowLayout = topCollectionViewForSelectedServices.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
           }

        arrayOfSelectedName = SideMenuSubServicesTableViewController.selectedServiesArray
        if SideMenuSubServicesTableViewController.selectedServiesArray.isEmpty == true {
            arrayOfSelectedName = CustomCategoryViewController.selectedServiesArray
        }
        filterArrayOfSelctedServicesName = arrayOfSelectedName.removingDuplicates()
    }

    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true

            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallary()
    {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }

        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true)
    }


    //Mark: - UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dateTimecollectionView {
            return  arrayForDateTimeCollectionView.count
        }
        else if collectionView == firstCollectionView {
            return dateArray.count
        }

        else {
            return filterArrayOfSelctedServicesName.count
        }
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == firstCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateandTimeCollectionViewCell", for: indexPath) as! DateandTimeCollectionViewCell
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.gray.cgColor
            cell.contentView.layer.masksToBounds = true
            let stringArray = useDateArray[indexPath.row].split(separator: Character(" "))
            cell.label.numberOfLines = 0
            cell.label.textAlignment = .center
            cell.label.font = UIFont.systemFont(ofSize: 16.0)
            cell.label.text = "\(stringArray.first ?? "") \n \(stringArray.last ?? "")"

            return cell
        }
        else if collectionView == dateTimecollectionView{

            let cell2 = dateTimecollectionView.dequeueReusableCell(withReuseIdentifier: "SecondCollectionViewCell", for: indexPath) as! SecondCollectionViewCell
            cell2.dateLabel.text = arrayForDateTimeCollectionView[indexPath.row]
            cell2.contentView.layer.borderWidth = 0.5
            cell2.contentView.layer.borderColor = UIColor.gray.cgColor
            cell2.contentView.layer.masksToBounds = true
            if selectedTimeIndex != nil && indexPath.row == selectedTimeIndex{
                cell2.dateLabel.textColor = .black
                cell2.mainView.backgroundColor = .white
            }
            return cell2

        }

        else {
            let cell3 = topCollectionViewForSelectedServices.dequeueReusableCell(withReuseIdentifier: "SelectedCollectionViewCell", for: indexPath) as! SelectedCollectionViewCell
            cell3.selecetdCategoryName.text = filterArrayOfSelctedServicesName[indexPath.row]
            if filterArrayOfSelctedServicesName.isEmpty == true  {
                cell3.selecetdCategoryName.text = arrayOfSelectedName[indexPath.row]
            }

            return cell3
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == firstCollectionView {
            return CGSize(width: 100, height: 50)
        }
        else if collectionView == dateTimecollectionView{
            return  CGSize(width: 90, height: 50)
        }
        else {
            return CGSize(width: 200, height: 40)
        }

    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == topCollectionViewForSelectedServices {
            return  20
        }
        else {
            return  0
        }
    }


    //MARK: -Interface Builder Actions
    @IBAction func locationButton(_ sender: UIButton) {
        navigate(.chooseLocationOnMap)
    }

    @IBAction func postButton(_ sender: UIButton) {

//            let imageSystem =  UIImage(named: "gallery icon")
            let value = Int(priceTextFeild.text ?? "0")
//
//
//            if selectImage.image?.pngData() == imageSystem?.pngData() {
//                openAlert(title: "Alert", message: "Please Select Photo", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
//                    print("Okay")
//                }])
//            }
           if locationLandmarkAddressTextFeild.text == "" {
                openAlert(title: "Alert", message: "Please Select location", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }
            else if priceTextFeild.text == "" {
                openAlert(title: "Alert", message: "Please Enter Price", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

            else if value!  < 10 {
                openAlert(title: "Alert", message: "Please Enter Price More than $10", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

            else if descriptionTextView.text.count < 1 {
                openAlert(title: "Alert", message: "Please Enter description", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }


//
//            else if selectedDate == nil {
//                openAlert(title: "Alert", message: "Please select Date", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
//                    print("Okay")
//                }])
//            }
//
//            else if selectedTime == nil {
//                openAlert(title: "Alert", message: "Please select Time", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
//                    print("Okay")
//                }])
//            }

            else {
                self.updateJobApi()
            }
        }

    //MARK: - UICollectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        firstCollectionView.allowsMultipleSelection = false
        dateTimecollectionView.allowsMultipleSelection = false
        if collectionView == firstCollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) as? DateandTimeCollectionViewCell {
                cell.label.textColor = .black
                cell.mainView.backgroundColor = .white
                self.selectedIndexPath = indexPath
                self.selectedDateIndex = indexPath.row
                let indexPath = collectionView.indexPathsForSelectedItems?.first
                let data = collectionView.cellForItem(at: indexPath!) as? DateandTimeCollectionViewCell
                let bh = data?.label.text
                selectedDate = bh

            }

        }

        if collectionView == dateTimecollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) as? SecondCollectionViewCell {
                selectedTimeIndex = indexPath.row
                cell.dateLabel.textColor = .black
                cell.mainView.backgroundColor = .white
                self.selectedIndexPath = indexPath
                let indexPath = collectionView.indexPathsForSelectedItems?.first
                let data = collectionView.cellForItem(at: indexPath!) as? SecondCollectionViewCell
                let bh = data?.dateLabel.text
                selectedTime = bh

            }
        }

    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }


    //MARK: - Calling Create Job API
    func callingCreateJobAPI() {
        self.showActivity()
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/createjob") else { return }
        print(gitUrl)
        let request = NSMutableURLRequest(url: gitUrl)
        let year = Calendar.current.component(.year, from: Date())
        let selDate = setDate(date: dateArray[selectedDateIndex])
        let dateWithoutNextSlashN = String(selectedDate!.filter { !"\r\n\n\t\r".contains($0) })
        let parameterDictionary =  ["booking_date":selDate!, "categoryId": UserStoreSingleton.shared.categoryId ?? "" ,"UserId" : UserStoreSingleton.shared.userID ?? "" ,"categoryName": UserStoreSingleton.shared.categoryName ?? "" ,"day": dateWithoutNextSlashN ,"time": selectedTime ?? "","subcategoryId": SideMenuSubServicesTableViewController.subcategoryList,"image": UserStoreSingleton.shared.profileImage ?? "","location": UserStoreSingleton.shared.Address ?? "","lat": UserStoreSingleton.shared.currentLat ?? "","lng":UserStoreSingleton.shared.currentLong ?? "" ,"price": priceTextFeild.text ?? "","jobStatus": "open","description": descriptionTextView.text ?? "" ] as [String: Any]

        print(parameterDictionary)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: [])
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            print("response---- \(response) , data\(data)")
            guard let data = data else { return }
            do {
                let gitData = try JSONDecoder().decode(CreateJobModel.self, from: data)
                print("response data:", gitData)
                DispatchQueue.main.async {
                    self.hideActivity()
                    let responseMeassge = gitData.status
                    if responseMeassge == 200 {
                        self.navigationController?.navigationBar.tintColor = UIColor.white
                        self.showMessage(gitData.message ?? "")
                        UserStoreSingleton.shared.jobId = gitData.jobId
                        self.navigate(.providerList)
                    }
                    else {
                        self.showMessage(gitData.message ?? "")
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }

    func getBookingDeatils() {
        self.showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-jobDetails/\(selectJob_id ?? 0)")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(getJobdetails.self, from: data ?? Data())
                debugPrint(json)
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.locationLandmarkAddressTextFeild.text = json.data?.location
                    self.priceTextFeild.text = json.data?.price
                    self.descriptionTextView.text = json.data?.description
                    self.dateVal = json.data?.day
                    self.timeVal = json.data?.time
                   }
            } catch {
                self.hideActivity()

                print(error)
            }
         }
        task.resume()
    }


    func updateJobApi() {
        self.showActivity()
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/update-job-location") else { return }
        print(gitUrl)
        let request = NSMutableURLRequest(url: gitUrl)
        let parameterDictionary = ["categoryId":UserStoreSingleton.shared.categoryId ?? "", "categoryName":UserStoreSingleton.shared.categoryName ?? "" , "price":priceTextFeild.text ?? "", "description":descriptionTextView.text ?? "", "location":UserStoreSingleton.shared.Address ?? "","lat":UserStoreSingleton.shared.currentLat ?? "" , "lng":UserStoreSingleton.shared.currentLong ?? "", "job_id":selectJob_id ?? 0] as [String: Any]

        print(parameterDictionary)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: [])
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            print("response---- \(response) , data\(data)")
            guard let data = data else { return }
            do {
                let gitData = try JSONDecoder().decode(updateJobWork.self, from: data)
                print("response data:", gitData)
                DispatchQueue.main.async {
                    self.hideActivity()
                    let responseMeassge = gitData.status
                    if responseMeassge == 200 {
                        self.navigationController?.navigationBar.tintColor = UIColor.white
                        self.showMessage(gitData.message ?? "")
                        self.firstCollectionView.isUserInteractionEnabled = true
                        self.dateTimecollectionView.isUserInteractionEnabled = true

                        self.navigate(.providerList)
                    }
                    else {
                        self.showMessage(gitData.message ?? "")
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }

    //MARK: - Calling Upload Image API
    func uploadImage(paramName: String, fileName: String, image: UIImage) {
        let url = URL(string: "http://3.18.59.239:3000/api/v1/upload")

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    if let imageData = json["data"] {
//                        UserStoreSingleton.shared.profileImage = imageData as! String

                    }
                }
            }
        }).resume()
    }

    func setDate(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }

    func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }

        switch src.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        }

        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        ctx.concatenate(transform)

        switch src.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }

        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)

        return img
    }
}









