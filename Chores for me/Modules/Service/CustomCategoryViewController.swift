//
//  CustomCategoryViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 05/08/21.
//

import UIKit
import SwiftyJSON

class CustomCategoryViewController: BaseViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {


    //MARK: - Interface Builder Outlets
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var categoryName: UITextField!


    //MARK: - Properties
    var imagePicker = UIImagePickerController()
    private var storeArray = NSArray()
    var arrayData:[AddCustomSubCategoryModel] = []
    var imageResponse: String?
    static var selectedServiesArray: [String] = []


    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        CustomCategoryViewController.selectedServiesArray.removeAll()
     //   CheckTimeFunc()
    }


    //MARK: - Interface Builder Actions
    @IBAction func didTappedImageView(_ sender: UITapGestureRecognizer) {
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

    @IBAction func customButtomAction(_ sender: UIButton) {
        let imageSystem =  UIImage(named: "user.profile.icon")
      if selectedImage.image?.pngData() == imageSystem?.pngData() {
            openAlert(title: "Alert", message: "select profile picture", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                print("Okay")
            }])
        }

      else if categoryName.text == ""{
            openAlert(title: "Alert", message: "enter category name", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                print("Okay")
            }])
        }
      else {
        self.callingAddCustomSubcategoryAPI()
      }
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
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }


    //MARK: - ImagePicker Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mySelectedImage = info[.originalImage] as? UIImage
        selectedImage.image = mySelectedImage
        uploadImage(paramName: "photo", fileName: "png", image: mySelectedImage!)
        imagePicker.dismiss(animated: true, completion: nil)
    }


    //MARK: - Calling API
   private func callingAddCustomSubcategoryAPI() {
        let Url = String(format: "http://3.18.59.239:3000/api/v1/add-custom-subcategory")
        guard let serviceUrl = URL(string: Url) else { return }
    let parameterDictionary =  ["categoryId": "4","subcategoryName": categoryName.text ?? "","subcategoryImage": imageResponse ?? ""] as [String: Any]
    CustomCategoryViewController.selectedServiesArray.append(categoryName.text!)

       let dic = NSMutableDictionary()
//       dic.setValue(String(subcategoryId!), forKey: "id")
       dic.setValue(categoryName.text, forKey: "name")
       dic.setValue("subcategoryImage", forKey: "image")

        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
    session.dataTask(with: request as URLRequest) { (data, response, error) in
            print("response---- \(response) , data\(data)")
            guard let data = data else { return }
            do {
                let gitData = try JSONDecoder().decode(AddCustomSubCategoryModel.self, from: data)
                print("response data:", gitData)
                DispatchQueue.main.async {
                    let responseMeassge = gitData.status
                    if responseMeassge == 200 {
                        self.showMessage(gitData.message ?? "")
                        dic.setValue(String(gitData.subcategoryId!), forKey: "id")
                        SideMenuSubServicesTableViewController.subcategoryList.add(dic)
                        self.navigate(.uploadProfilePicture)
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
//                self.hideActivity()
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    DispatchQueue.main.async {
                    if let imageData = json["data"] {
                        self.imageResponse = imageData as? String
                        print(imageData)
                    }
                    }

                }
            }
        }).resume()
    }

}


