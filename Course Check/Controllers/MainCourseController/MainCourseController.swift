//
//  MainCourseController.swift
//  Course Check
//
//  Created by Sanchez on 10.09.2023.
//

import UIKit
import Combine
import SnapKit

class MainCourseController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerMainView: UIView!
    
    @IBOutlet weak var rublesTextField: UITextField!
    @IBOutlet weak var symResultLabel: UILabel!
    @IBOutlet weak var dollarResultLabel: UILabel!
    
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var currencyChooseButton: UIButton!
    @IBOutlet weak var rubResultLabel: UILabel!
    
    var symCourse: Double?
    var dollarCourse: Double?
    
    var choosedCurrency: Currencies = .usd
    
    private(set) var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        self.title = "Курсы"
        setupUI()
//        binding()
        updateRates(date: Date())
        
        rublesTextField.addTarget(self, action: #selector(rubleConvertAction), for: .editingChanged)
        currencyTextField.addTarget(self, action: #selector(currencyConvertAction), for: .editingChanged)
    }
    
    private func setupUI() {
        let symCurr = UIAction(title: "cум") { action in
            self.choosedCurrency = .sym
            self.userCurrencyCounting()
        }
        let usdCurr = UIAction(title: "$") { action in
            self.choosedCurrency = .usd
            self.userCurrencyCounting()
        }

        
            
            
        
        let menuElements: [UIAction] = [usdCurr, symCurr]
        let menu = UIMenu(title: "Валюта", children: menuElements)
        currencyChooseButton.menu = menu
    }
    
    private func updateRates(date: Date) {
        // Создаем объект DateFormatter для форматирования даты и времени
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Преобразуем дату в строку в нужном формате
        let formattedDate = dateFormatter.string(from: date)
        
        NetworkManager().getSymRate(date: formattedDate) { symCourseModel in
            guard let symCourseModel = symCourseModel.first else { return }
            self.symCourse = symCourseModel.rate.toDouble()
            
            self.userRubToSymCounting()
            self.userCurrencyCounting()
        } errorClosure: {
            self.symCourse = nil
            
            self.userRubToSymCounting()
            self.userCurrencyCounting()
        }
        
//        NetworkManager().getUsdRateOpenexchangerates(date: formattedDate) { usdCourseModel in
//            self.dollarCourse = 1 / usdCourseModel.rate.rub
//
//            self.userRubToUsdCounting()
//            self.userCurrencyCounting()
//        } errorClosure: {
//            self.dollarCourse = nil
//
//            self.userRubToUsdCounting()
//            self.userCurrencyCounting()
//        }
        
        NetworkManager().getUsdRateMoex(date: formattedDate) { usdCourseModelMoex in
            if let usdCourseMoex = usdCourseModelMoex.securities.data.first?.last {
                self.dollarCourse = 1 / usdCourseMoex
            } else {
                self.dollarCourse = nil
            }
            
            self.userRubToUsdCounting()
            self.userCurrencyCounting()
        } errorClosure: {
            self.dollarCourse = nil
            
            self.userRubToUsdCounting()
            self.userCurrencyCounting()
        }
    }
    
    private func userRubToSymCounting() {
        if self.symCourse == nil {
            self.dollarResultLabel.text = "ошибка загрузки"
        } else {
            let symCount = (self.symCourse ?? 0) * (self.rublesTextField.text?.toDouble() ?? 1)
            self.symResultLabel.text = "\(symCount.roundForSignsAfterDot(1).toString()) сум"
        }
    }
    
    private func userRubToUsdCounting() {
        if self.dollarCourse == nil {
            self.dollarResultLabel.text = "ошибка загрузки"
        } else {
            let dollarCount = (self.dollarCourse ?? 0) * (self.rublesTextField.text?.toDouble() ?? 1)
            self.dollarResultLabel.text = "\(dollarCount.roundForSignsAfterDot(2).toString()) $"
        }
    }
    
    private func userCurrencyCounting() {
        switch choosedCurrency {
        case .sym:
            guard let symCourse else {
                rubResultLabel.text = "ошибка загрузки"
                return
            }
            rubResultLabel.text = ((currencyTextField.text?.toDouble() ?? 1) / symCourse).roundForSignsAfterDot(2).toString() + " ₽"
        case .usd:
            guard let dollarCourse else {
                rubResultLabel.text = "ошибка загрузки"
                return
            }
            rubResultLabel.text = ((currencyTextField.text?.toDouble() ?? 1) / dollarCourse).roundForSignsAfterDot(2).toString() + " ₽"
        }
    }
    
    private func binding() {
        
    }
    
    @objc private func rubleConvertAction() {
        userRubToSymCounting()
        userRubToUsdCounting()
    }
    
    @objc private func currencyConvertAction() {
        userCurrencyCounting()
    }
    
    @IBAction func datePickerChangedAction(_ sender: Any) {
        updateRates(date: datePicker.date)
    }
    
    
}
