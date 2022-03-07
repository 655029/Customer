//
//  ResetPasswordModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 09/09/21.
//

import Foundation
struct ResetPasswordModel : Codable {
    let status : Int?
    let data : ResetPasswordData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}

struct ResetPasswordData : Codable {

   
}
