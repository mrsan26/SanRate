//
//  SymCourseModel.swift
//  Course Check
//
//  Created by Sanchez on 10.09.2023.
//

import Foundation

struct SymCourseModel: Decodable {
    var rate: String
    var diff: String
    var date: String
    
    enum CodingKeys: String, CodingKey {
        case rate = "Rate"
        case diff = "Diff"
        case date = "Date"
    }
}
