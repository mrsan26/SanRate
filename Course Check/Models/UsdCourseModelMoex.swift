//
//  UsdCourseModelMoex.swift
//  Course Check
//
//  Created by Sanchez on 12.09.2023.
//

import Foundation

struct UsdCourseModelMoex: Decodable {
    var securities: Securities
}

struct Securities: Decodable {
    var data: [[Double]]
}
