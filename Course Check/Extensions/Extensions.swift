//
//  Extensions.swift
//  Course Check
//
//  Created by Sanchez on 10.09.2023.
//

import Foundation
import UIKit

extension String {
    func toInt() -> Int? {
        return Int(self)
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
}

extension Int {
    func toString() -> String {
        return String(self)
    }
}

extension Double {
    func toString() -> String {
        return String(self)
    }
    
    func roundForSignsAfterDot(_ signs: Int) -> Double {
        var multiplier: Double = 1
        for _ in 1...signs {
            multiplier *= 10
        }
        return (self * multiplier).rounded() / multiplier
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
