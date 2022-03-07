//
//  NotificationModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 28/09/21.
//

import Foundation

struct NotificationAPIModel : Codable {
    let status : Int?
    let data : [NotificationData]?
    let message : String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }

}

struct NotificationData : Codable {
    let id : Int?
    let user_id : Int?
    let job_id : Int?
    let provider_id : Int?
    let text : String?
    let type : String?
    let cancel_reason : String?
    let payment_status : String?
    let totalTime : String?


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case user_id = "user_id"
        case job_id = "job_id"
        case provider_id = "provider_id"
        case text = "text"
        case type = "type"
        case cancel_reason = "cancel_reason"
        case payment_status = "payment_status"
        case totalTime = "totalTime"
    }

}
