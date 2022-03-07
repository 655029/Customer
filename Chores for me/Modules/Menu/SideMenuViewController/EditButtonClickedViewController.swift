//
//  EditButtonClickedViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 26/07/21.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Toast_Swift
import SDWebImage

class EditButtonClickedViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    

    //MARK:- Interface Builder Outlets
    @IBOutlet weak private var profileImageView: UIImageView!
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var nameTextFeild: UITextField!
    @IBOutlet weak private var emailTextFeild: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak private var numberTextFeild: UITextField!
    @IBOutlet weak private var passwordTextFeild: UITextField!


    //MARK:- Properties
    var imagePicker = UIImagePickerController()
    static var editName: String?
    var imageurl: String?
    var photoURL : URL!


    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserProfile()
        navigationController?.navigationItem.title = "Profile"
       // navigationController?.navigationBar.tintColor = .systemBlue
        tabBarController?.tabBar.isHidden = true
        let textFeilds = [nameTextFeild,lastNameTextField,emailTextFeild,numberTextFeild,passwordTextFeild]
        for item in textFeilds {
            item?.layer.borderWidth = 0.5
            item?.layer.cornerRadius = 10.0
            item?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: (item?.frame.height)!))
            item?.leftViewMode = .always
        }
            emailTextFeild.text = UserStoreSingleton.shared.email
        if UserStoreSingleton.shared.phoneNumber == nil {
            numberTextFeild.text = UserStoreSingleton.shared.socailPhoneNumber
        }
        else {
            numberTextFeild.text = UserStoreSingleton.shared.phoneNumber

        }
            nameTextFeild.text = UserStoreSingleton.shared.name
            lastNameTextField.text = UserStoreSingleton.shared.lastname
            EditButtonClickedViewController.editName = nameTextFeild.text
            UserStoreSingleton.shared.name = nameTextFeild.text

        let imagePath = UserStoreSingleton.shared.profileImage ?? ""
        if imagePath == "http://3.128.96.192:3000/profile.png" {
            let socailUrlString = UserStoreSingleton.shared.socailProfileImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
            let socailImageurl = URL(string: socailUrlString)
            self.imageurl = socailUrlString
            self.profileImageView.sd_setImage(with: socailImageurl, placeholderImage: UIImage(named: "upload profile picture"))
        }
        else {
        let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
        let url = URL(string: urlString)
        self.imageurl = urlString
        self.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "upload profile picture"))
        }
        imagePicker.delegate = self
        let sec = UIBarButtonItem(title: "Save", style: .done, target: self, action:  #selector(rightBarButton))
        sec.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: AppFont.Poppins.semiBold.fontName, size: 22.0)!], for: .normal)
        navigationItem.rightBarButtonItem = sec
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
      //  navigationController?.navigationBar.tintColor = .red
    }

    //MARK: - Interface Builder Actions
    @IBAction func didTapEditButton(_ sender: UIButton) {
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

    @IBAction func saveButtonAction(_ sender: UIButton) {

    }

    @IBAction func changePasswordButtonAction(_ sender: UIButton) {
        navigate(.resetPassword)
    }

    @objc private func rightBarButton(_ sender: UIBarButtonItem) {
        updateProfileAPI()
    }


    //MARK: - ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImage = self.imageOrientation(selectedImage)
        self.profileImageView.sd_setImage(with: photoURL, placeholderImage: UIImage(contentsOfFile: "upload profile picture"))
        if (picker.sourceType == .photoLibrary) {
            if let imgUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                let pickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                profileImageView.image = pickerImage
                let imgName = imgUrl.lastPathComponent
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)

                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                let data = image.jpegData(compressionQuality: 0.3)! as NSData
                data.write(toFile: localPath, atomically: true)
                photoURL = URL.init(fileURLWithPath: localPath)
                print(photoURL!)

            }
        }
        else
        {
            let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            profileImageView.image = pickedImage
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            let data = pickedImage!.jpegData(compressionQuality: 0.3)! as NSData
            data.write(toFile: localPath, atomically: true)
            photoURL = URL.init(fileURLWithPath: localPath)
            print(photoURL!)
            picker.dismiss(animated: true, completion: nil)
        }
        self.dismiss(animated: true, completion: nil)
        uploadImage(paramName: "photo", fileName: "png", image: selectedImage)
    }


    //MARK: - Additional Helpers
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
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
        imagePicker.navigationBar.tintColor = .systemBlue
        imagePicker.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    func showActivity() {
        let activityData = ActivityData(size: CGSize(width: 30, height: 30), type: .circleStrokeSpin, color: .white, backgroundColor: UIColor(named: "AppColor"))
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }

    func hideActivity() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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


    //MARK: - Calling API
    func updateProfileAPI() {
        if imageurl == nil || imageurl == ""  {
            navigate(.HomePage)
            return
        }
        let Url = String(format: "http://3.18.59.239:3000/api/v1/update-profile")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary =  ["first_name":nameTextFeild.text ?? "","last_name":lastNameTextField.text ?? "","email":emailTextFeild.text ?? "", "image": imageurl ?? ""] as [String : Any]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue(UserStoreSingleton.shared.Token ?? "" , forHTTPHeaderField: "authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
                    let gitData = try JSONDecoder().decode(UpdateUserProfile.self, from: data)
                    DispatchQueue.main.async {
                        let responseMeassage = gitData.status
                        if responseMeassage == 200 {
                            UserStoreSingleton.shared.name = self.nameTextFeild.text
                            UserStoreSingleton.shared.lastname = self.lastNameTextField.text
                            self.navigate(.HomePage)
                            self.showMessage(gitData.message ?? "")
                        }

                        else {
                            self.showMessage(gitData.message ?? "")
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()

    }
    
    func getUserProfile() {
        self.showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-user-Profile")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(SetUpProfile.self, from: data ?? Data())
                debugPrint(json)
                DispatchQueue.main.async {
                    self.hideActivity()
                    UserStoreSingleton.shared.name = json.data?.first_name
                    let name = json.data?.name
                    if json.data?.first_name == nil {
                        let fullName = name
                        let fullNameArr = fullName?.components(separatedBy: " ")
                        let firstName = fullNameArr?[0]
                        let lastName = fullNameArr?[1]
                        UserStoreSingleton.shared.name = firstName
                        self.lastNameTextField.text = lastName
                        UserStoreSingleton.shared.email = json.data?.email
                    }
                    else {
                        UserStoreSingleton.shared.name = json.data?.first_name
                    }
                    UserStoreSingleton.shared.lastname = json.data?.last_name
                    _ = json.data?.image
                    UserStoreSingleton.shared.userID = json.data?.userId
                    let photoUrl = URL(string: (json.data?.image ?? "" ))
                    if json.data?.image != nil {
                        UserStoreSingleton.shared.profileImage = json.data?.image
                    }
                    print(photoUrl as Any)
                   }
            } catch {
                self.hideActivity()

                print(error)
            }

        }
        task.resume()
    }

    func uploadImage(paramName: String, fileName: String, image: UIImage) {
        self.showActivity()
        let url = URL(string: "http://3.18.59.239:3000/api/v1/upload")

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let session = URLSession.shared
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        let jpegData = image.jpegData(compressionQuality: 1.0)
        data.append(image.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                self.hideActivity()
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    self.hideActivity()
                    if let imageData = json["data"] {
                        print(imageData)
                        self.imageurl = imageData as? String
//                        UserStoreSingleton.shared.profileImage = imageData as? String
                        let photoUrl = URL(string: self.imageurl ?? "")
                        DispatchQueue.main.async {
                            self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
                            self.profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(contentsOfFile: "upload profile picture"))

                        }

                    }

                }
            }
        }).resume()
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
