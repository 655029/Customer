//
//  AddCustomSubCategoryModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 24/09/21.
//

import Foundation
struct AddCustomSubCategoryModel : Codable {
    let status : Int?
    let subcategoryId : Int?
    let message : String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case subcategoryId = "subcategoryId"
        case message = "message"
    }
}
