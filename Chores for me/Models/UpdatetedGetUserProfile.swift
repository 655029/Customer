//
//  UpdatetedGetUserProfile.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 26/10/21.
//

import Foundation
import Foundation



import Foundation
struct UpdatetedGetUserProfile : Codable {
    let status : Int?
    let data : UpdatedData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}

struct UpdatedData : Codable {
    let userId : Int?
    let name : String?
    let email : String?
    let phone : String?
    let otp : String?
    let password : String?
    let image : String?
    let user_verified : Int?
    let signupType : Int?
    let socialKey : String?
    let lat : String?
    let lng : String?
    let location_address : String?
    let radius : String?
    let availability_provider_days : String?
    let availability_provider_timing : String?
    let deviceID : String?
    let avgRatings : Int?
    let deviceType : String?
    let createdAt : String?

    enum CodingKeys: String, CodingKey {

        case userId = "UserId"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case otp = "otp"
        case password = "password"
        case image = "image"
        case user_verified = "user_verified"
        case signupType = "signupType"
        case socialKey = "socialKey"
        case lat = "lat"
        case lng = "lng"
        case location_address = "location_address"
        case radius = "radius"
        case availability_provider_days = "availability_provider_days"
        case availability_provider_timing = "availability_provider_timing"
        case deviceID = "deviceID"
        case avgRatings = "AvgRatings"
        case deviceType = "deviceType"
        case createdAt = "createdAt"
    }


}
