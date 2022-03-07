//
//  Model.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 23/08/21.
//

import Foundation
struct  RegisterModel : Codable {
    let status : Int?
    let data : Regdata?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}
struct Regdata : Codable {
}

struct CancelJobByCustomer : Codable {
    let status : Int?
    let data : CancelData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct CancelData : Codable {
    let minutes : Int?
    let isChargeable : Bool?

    enum CodingKeys: String, CodingKey {

        case minutes = "minutes"
        case isChargeable = "isChargeable"
    }
}


