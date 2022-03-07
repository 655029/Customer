//
//  SocialSignInModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 10/09/21.
//

import Foundation
struct SocailSignInModel : Codable {
    let status : Int?
    let data : SocailSignIndata?
    let message : String?
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }

}

struct SocailSignIndata : Codable {
    let token : String?
    let phone : String?

    enum CodingKeys: String, CodingKey {
        case token = "token"
        case phone = "phone"
    }

}
