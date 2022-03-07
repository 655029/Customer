//
//  DeleteJobAPIModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 17/11/21.
//

import Foundation
struct DeleteJobAPIModel : Codable {
    let status : Int?
    let data : DeleteedData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}


struct DeleteedData : Codable {

}
