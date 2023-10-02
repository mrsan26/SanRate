//
//  NetworkManager.swift
//  Course Check
//
//  Created by Sanchez on 10.09.2023.
//

import Foundation
import Moya

typealias SuccessClosureArray<T: Decodable> = (([T]) -> Void)
typealias SuccessClosure<T: Decodable> = ((T) -> Void)
typealias ErrorClosure = (() -> ())

class NetworkManager {
    private let provider = MoyaProvider<BackendApi>(plugins: [NetworkLoggerPlugin()])
    
    func getSymRubRate(date: String, success: SuccessClosureArray<SymCourseModel>?, errorClosure: ErrorClosure?) {
        provider.request(.getSymRubCourse(date: date)) { result in
            switch result {
            case .success(let response):
                do {
                    let result = try JSONDecoder().decode([SymCourseModel].self, from: response.data)
                    success?(result)
                } catch let error {
                    print(error)
                    errorClosure?()
                }
            case .failure(let error):
                print("Ошибка: \(error)")
                errorClosure?()
            }
        }
    }
    
    func getSymUsdRate(date: String, success: SuccessClosureArray<SymCourseModel>?, errorClosure: ErrorClosure?) {
        provider.request(.getSymUsdCourse(date: date)) { result in
            switch result {
            case .success(let response):
                do {
                    let result = try JSONDecoder().decode([SymCourseModel].self, from: response.data)
                    success?(result)
                } catch let error {
                    print(error)
                    errorClosure?()
                }
            case .failure(let error):
                print("Ошибка: \(error)")
                errorClosure?()
            }
        }
    }
    
    func getUsdRateOpenexchangerates(date: String, success: SuccessClosure<UsdCourseModelOpenexchangerates>?, errorClosure: ErrorClosure?) {
        provider.request(.getUsdCourseOpenexchangerates(date: date)) { result in
            switch result {
            case .success(let response):
                do {
                    let result = try JSONDecoder().decode(UsdCourseModelOpenexchangerates.self, from: response.data)
                    success?(result)
                } catch let error {
                    print(error)
                    errorClosure?()
                }
            case .failure(let error):
                print("Ошибка: \(error)")
                errorClosure?()
            }
        }
    }
    
    func getUsdRateMoex(fromDate: String, tillDate: String, success: SuccessClosure<UsdCourseModelMoex>?, errorClosure: ErrorClosure?) {
        provider.request(.getUsdCourseMoex(fromDate: fromDate, tillDate: tillDate)) { result in
            switch result {
            case .success(let response):
                do {
                    let result = try JSONDecoder().decode(UsdCourseModelMoex.self, from: response.data)
                    success?(result)
                } catch let error {
                    print(error)
                    errorClosure?()
                }
            case .failure(let error):
                print("Ошибка: \(error)")
                errorClosure?()
            }
        }
    }
}
