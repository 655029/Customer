//
//  SubCategoryList.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 31/08/21.
//

import Foundation
import SwiftyJSON

struct SubCatgeoryModel {
    var subcategoryId : Int?
    var categoryId : String?  = ""
    var subcategoryName : String?  = ""
    var subcategoryImage : String?  = ""
    var status : String?  = ""
    init() {
    }
    init(json:JSON){
        subcategoryName = json["subcategoryName"].stringValue
        subcategoryImage = json["subcategoryImage"].stringValue
        subcategoryId = json["subcategoryId"].int
        categoryId = json["categoryId"].stringValue
    }
    }
