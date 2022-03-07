//
//  UpdateUserProfile.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 31/08/21.
//

import Foundation
struct UpdateUserProfile : Codable {
    let status : Int?
    let data : UpdateProfileData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}
struct UpdateProfileData : Codable {

}
