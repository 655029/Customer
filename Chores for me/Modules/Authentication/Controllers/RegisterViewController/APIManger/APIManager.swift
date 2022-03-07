//
//  APIManager.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 23/08/21.
//

import Foundation
import Alamofire


enum APIerrors: Error{
    case custom(meassage: String)

}
typealias Handler = (Swift.Result<Any?, APIerrors>) -> Void

class APIManager {
    static let shareInstance = APIManager()

//    func calllingRegisterAPI(register: RegisterModel) {
//        let headers: HTTPHeaders = [
//            .contentType("application/json")]
//
//        Alamofire.request(registerUrl, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response {
//            response in
//            debugPrint(response)
//            switch response.result{
//            case .success(let data ):
//                do{
//                    let json =  try JSONSerialization.jsonObject(with: data!, options: [])
//                    if response.response?.statusCode == 200 {
//
//                    }
//                    print(json)
//                }
//                catch{
//
//                }
//            case .failure(let err) :
//                print(err.localizedDescription)
//            }
//
//
//        }
//
//        }


//    func callingLoginAPI(login: LoginModel, completionHandler: @escaping Handler) {
//        let headers: HTTPHeaders = [
//            .contentType("application")
//        ]
//
//        Alamofire.request(loginURL, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
//            debugPrint(response)
//
//            switch response.result{
//            case .success(let data):
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                    if response.response?.statusCode == 200{
//                        completionHandler(.success(json))
//                    }
//                    else {
//                        completionHandler(.failure(.custom(meassage: "Please check your network conectivity")))
//                    }
//
//                }
//
//                catch {
//                    print(error.localizedDescription)
//                    completionHandler(.failure(.custom(meassage: "Please try again")))
//
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//                completionHandler(.failure(.custom(meassage: "Please try again")))
//            }
//        }
//
//
//    }


}
