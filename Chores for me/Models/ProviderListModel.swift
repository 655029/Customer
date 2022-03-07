//
//  ProviderListModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 06/09/21.
//

import Foundation
import SwiftyJSON


struct ProviderListModel {
    var userId : Int?
    var name : String?
    var first_name : String?
    var last_name : String?
    var email : String?
    var phone : String?
    var otp : String?
    var password : String?
    var image : String?
    var user_verified : Int?
    var signupType : Int?
    var socialKey : String?
    var lat : String?
    var lng : String?
    var location_address : String?
    var radius : String?
    var availability_provider_days : String?
    var availability_provider_timing : String?
    var deviceID : String?
    var deviceType : String?
    var createdAt : String?
    var subcategoryId : String?
    var subcategoryName : String?
    var subcategoryPrice : String?
    var categoryName : String?
    var work_exp : String?
    var exp_desciption : String?
    var distance : Int?
    var rating : Double?
    init(){
        
    }

    init(json:JSON) {
        userId = json["UserId"].intValue
        name = json["name"].stringValue
        first_name = json["first_name"].stringValue
        last_name = json["last_name"].stringValue
        email = json["email"].stringValue
        phone = json["phone"].stringValue
        otp = json["otp"].stringValue
        password = json["password"].stringValue
        image = json["image"].stringValue
        user_verified = json["user_verified"].int
        signupType = json["signupType"].int
        socialKey = json["socialKey"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        location_address = json["location_address"].stringValue
        radius = json["radius"].stringValue
        availability_provider_days = json["availability_provider_days"].stringValue
        availability_provider_timing = json["availability_provider_timing"].stringValue
        deviceID = json["deviceID"].stringValue
        deviceType = json["deviceType"].stringValue
        createdAt = json["createdAt"].stringValue
        subcategoryId = json["subcategoryId"].stringValue
        subcategoryName = json["subcategoryName"].stringValue
        subcategoryPrice = json["subcategoryPrice"].stringValue
        categoryName = json["categoryName"].stringValue
        work_exp = json["work_exp"].stringValue
        exp_desciption = json["exp_desciption"].stringValue
        distance = json["distance"].intValue
        rating = json["rating"].doubleValue
    }
}


