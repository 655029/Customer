//
//  JobsHistoryModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 16/09/21.
//

import Foundation
struct JobsHistoryModel : Codable {
    let status : Int?
    let data : [JobHistoryData]?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}

struct savePaymentModel : Codable {
    let status : Int?
    let data : saveData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}
struct saveData : Codable {


}

struct JobHistoryData : Codable {
    let jobId : Int?
    let userId : String?
    let categoryId : String?
    let categoryName : String?
    let subcategoryId : [JobsSubcategoryId]?
    let image : String?
    let location : String?
    let price : String?
    let description : String?
    let lat : String?
    let lng : String?
    let day : String?
    let time : String?
    let providerId : String?
    var providerDetails : ProviderDetails?
    let jobStatus : String?
    let createdAt : String?
    let booking_date : String?
    let first_name : String?
    let last_name: String?
    let total_time: String?

    enum CodingKeys: String, CodingKey {

        case jobId = "jobId"
        case userId = "UserId"
        case first_name = "first_name"
        case last_name = "last_name"
        case total_time = "total_time"
        case categoryId = "categoryId"
        case categoryName = "categoryName"
        case subcategoryId = "subcategoryId"
        case image = "image"
        case location = "location"
        case price = "price"
        case description = "description"
        case lat = "lat"
        case lng = "lng"
        case day = "day"
        case time = "time"
        case providerId = "providerId"
        case providerDetails = "providerDetails"
        case jobStatus = "jobStatus"
        case createdAt = "createdAt"
        case booking_date = "booking_date"
    }

}

struct ProviderDetails : Codable {
    let userId : Int?
    let first_name : String?
    let phone : String?
    let image : String?
    let email : String?
    let rating : Double?
    var work_exp : String?

    enum CodingKeys: String, CodingKey {

        case userId = "UserId"
        case first_name = "first_name"
        case phone = "phone"
        case image = "image"
        case email = "email"
        case rating = "rating"
        case work_exp = "work_exp"
    }
}

struct JobsSubcategoryId : Codable {
    let id : String?
    let name : String?
    let price : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case price = "price"
    }


}
