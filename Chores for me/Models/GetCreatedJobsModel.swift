//
//  GetCreatedJobsModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 15/09/21.
//

import Foundation
struct GetCratedJobsModel1 : Codable {
    let status : Int?
    let data : [GetJobsCreatedJobData]?
    let message : String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct GetJobsCreatedJobData : Codable {
    let jobId : Int?
    let userId : String?
    let categoryId : String?
    let categoryName : String?
    let subcategoryId : [SubcategoryId2]?
    let image : String?
    let location : String?
    let price : String?
    let description : String?
    let lat : String?
    let lng : String?
    let day : String?
    let time : String?
    let providerId : String?
    let jobStatus : String?
    let createdAt : String?

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
        case providerId = "providerId"
        case jobStatus = "jobStatus"
        case createdAt = "createdAt"
    }

}

struct SubcategoryId2 : Codable {
    let id : String?
    let name : String?
    let price : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case price = "price"
    }

}

