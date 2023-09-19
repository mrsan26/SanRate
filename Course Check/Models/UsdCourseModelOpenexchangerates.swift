//
//  UsdCourseModel.swift
//  Course Check
//
//  Created by Sanchez on 11.09.2023.
//

import Foundation

struct UsdCourseModelOpenexchangerates: Decodable {
    var rate: Rub
    
    enum CodingKeys: String, CodingKey {
        case rate = "rates"
    }
}

struct Rub: Decodable {
    var rub: Double
    
    enum CodingKeys: String, CodingKey {
        case rub = "RUB"
    }
}
