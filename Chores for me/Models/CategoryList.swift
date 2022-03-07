//
//  CategoryList.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 31/08/21.
//

import Foundation

struct CategoryList : Codable {
    let status : Int?
    let data : [CategoryData]?
    let message : String?
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct CategoryData : Codable {
    let categoryId : Int?
    let categoryName : String?
    let categoryImage : String?

    enum CodingKeys: String, CodingKey {
        case categoryId = "categoryId"
        case categoryName = "categoryName"
        case categoryImage = "categoryImage"
    }

}
