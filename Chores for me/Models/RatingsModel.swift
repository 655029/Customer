//
//  RatingsModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 22/09/21.
//

import Foundation
struct RatingsModel : Codable {
    let status : Int?
    let data : RatingData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}

struct RatingData : Codable {

}
