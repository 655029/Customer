//
//  VerifyOtpWithEmail.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 28/09/21.
//

import Foundation
struct VerifyOtpWithEmailModel : Codable {
    let status : Int?
    let data : VerifyEmailOtpData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }


}

struct VerifyEmailOtpData : Codable {
    let token : String?

    enum CodingKeys: String, CodingKey {

        case token = "token"
    }
}

