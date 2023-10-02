//
//  BackendAPI.swift
//  Course Check
//
//  Created by Sanchez on 10.09.2023.
//

import Foundation
import Moya

//http://iss.moex.com/iss/statistics/engines/futures/markets/indicativerates/securities/USD/RUB.json?from=2023-09-12&till=2023-09-12&iss.meta=off&iss.only=history&securities.columns=rate

enum BackendApi {
    case getSymRubCourse(date: String)
    case getSymUsdCourse(date: String)
    case getUsdCourseOpenexchangerates(date: String)
    case getUsdCourseMoex(fromDate: String, tillDate: String)
}

extension BackendApi: TargetType {
    var baseURL: URL {
        switch self {
        case .getSymRubCourse:
            return URL(string: "https://cbu.uz/ru/arkhiv-kursov-valyut/json/RUB/")!
        case .getSymUsdCourse:
            return URL(string: "https://cbu.uz/ru/arkhiv-kursov-valyut/json/USD/")!
        case .getUsdCourseOpenexchangerates:
            return URL(string: "https://openexchangerates.org/api/historical/")!
        case .getUsdCourseMoex:
            return URL(string: "https://iss.moex.com/iss/statistics/engines/futures/markets/indicativerates/securities/")!
        }
    }
    
    var path: String {
        switch self {
        case .getSymRubCourse(let date):
            return "\(date)/"
        case .getSymUsdCourse(let date):
            return "\(date)/"
        case .getUsdCourseOpenexchangerates(date: let date):
            return "\(date).json"
        case .getUsdCourseMoex:
            return "USD/RUB.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSymRubCourse:
            return .get
        case .getSymUsdCourse:
            return .get
        case .getUsdCourseOpenexchangerates:
            return .get
        case .getUsdCourseMoex:
            return .get
        }
    }
    
    var task: Moya.Task {
        guard let params else { return .requestPlain }
        return .requestParameters(parameters: params, encoding: encoding)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var params: [String: Any]? {
        var params = [String: Any]()
        switch self {
        case .getSymRubCourse:
            break
        case .getSymUsdCourse:
            break
        case .getUsdCourseOpenexchangerates:
            params["app_id"] = "d6659a4f3cd445969e400b6e6905c12e"
            params["base"] = "USD"
            params["symbols"] = "RUB"
        case .getUsdCourseMoex(fromDate: let fromDate, tillDate: let tillDate):
            params["from"] = fromDate
            params["till"] = tillDate
            params["iss.meta"] = "off"
            params["iss.only"] = "history"
            params["securities.columns"] = "rate"
        }
        return params
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getSymRubCourse:
            return URLEncoding.queryString
        case .getSymUsdCourse:
            return URLEncoding.queryString
        case .getUsdCourseOpenexchangerates:
            return URLEncoding.queryString
        case .getUsdCourseMoex:
            return URLEncoding.queryString
        }
    }
}
