//
//  LogoutModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 08/09/21.
//

import Foundation
struct logoutModel : Codable {
    let status : Int?
    let data : loginData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}

struct loginData : Codable {

}

