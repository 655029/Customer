//
//  CreateJobModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 03/09/21.
//

import Foundation
struct CreateJobModel : Codable {
    let status : Int?
    let data : CreateJobData?
    let jobId : Int?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case jobId = "jobId"
        case message = "message"
    }

}

struct CreateJobData : Codable {

    }


struct getJobdetails : Codable {
    let status : Int?
    let data : JobDetailData?
    let jobId : String?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case jobId = "jobId"
        case message = "message"
    }
}

struct JobDetailData : Codable {
    let jobId : Int?
    let userId : String?
    let categoryId : String?
    let categoryName : String?
    let subcategoryId : [SubcategoryId]?
    let image : String?
    let location : String?
    let price : String?
    let description : String?
    let lat : String?
    let lng : String?
    let day : String?
    let time : String?
    let jobStatus : String?
    let createdAt : String?
    let booking_date : String?
    let accept_time : String?
    let userDetails : UserDetails?
    let providerDetails : ProviderDetails?

    enum CodingKeys: String, CodingKey {

        case jobId = "jobId"
        case userId = "UserId"
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
        case jobStatus = "jobStatus"
        case createdAt = "createdAt"
        case booking_date = "booking_date"
        case accept_time = "accept_time"
        case userDetails = "userDetails"
        case providerDetails = "providerDetails"
    }
}

struct SubcategoryId : Codable {
    let id : String?
    let name : String?
    let price : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case price = "price"
    }
}


struct updateJobWork : Codable {
    let status : Int?
    let data : UpdateData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
    struct UpdateData : Codable {



    }


}
