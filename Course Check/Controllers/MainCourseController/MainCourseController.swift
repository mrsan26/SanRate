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
    
    @IBOutlet weak var rubleConvertionMainView: BackgroundView!
    @IBOutlet weak var currencyConvertionMainView: BackgroundView!
    
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
        let symCurr = UIAction(title: UIStrings.cym.rawValue) { action in
            self.choosedCurrency = .sym
            self.userCurrencyCounting()
        }
        let usdCurr = UIAction(title: UIStrings.usd.rawValue) { action in
            self.choosedCurrency = .usd
            self.userCurrencyCounting()
        }
        let menuElements: [UIAction] = [usdCurr, symCurr]
        let menu = UIMenu(title: "Валюта", children: menuElements)
        currencyChooseButton.menu = menu
        
        let settingsTopBarButton = UIBarButtonItem(title: "Настройки", style: .plain, target: self, action: #selector(settingsButtonAction))
        navigationItem.rightBarButtonItem = settingsTopBarButton
    }
    
    private func updateRates(date: Date) {
        // Создаем объект DateFormatter для форматирования даты и времени
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Преобразуем дату в строку в нужном формате
        let formattedDate = dateFormatter.string(from: date)
        
        if let userSymRate: Double = UserManager.read(.userSymRate) {
            self.symCourse = userSymRate
            
            self.userRubToSymCounting()
            self.userCurrencyCounting()
            
            symResultLabel.textColor = .systemPink
        } else {
            NetworkManager().getSymRubRate(date: formattedDate) { symCourseModel in
                guard let symCourseModel = symCourseModel.first else { return }
                self.symCourse = symCourseModel.rate.toDouble()
                
                self.userRubToSymCounting()
                self.userCurrencyCounting()
            } errorClosure: {
                self.symCourse = nil
                
                self.userRubToSymCounting()
                self.userCurrencyCounting()
            }
        }
        
        switch (UserManager.read(.usdMode) ?? 0) as Int {
        case 0:
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
        case 1:
            NetworkManager().getUsdRateOpenexchangerates(date: formattedDate) { usdCourseModel in
                self.dollarCourse = 1 / usdCourseModel.rate.rub

                self.userRubToUsdCounting()
                self.userCurrencyCounting()
            } errorClosure: {
                self.dollarCourse = nil

                self.userRubToUsdCounting()
                self.userCurrencyCounting()
            }
        case 2:
            NetworkManager().getSymUsdRate(date: formattedDate) { symCourseModel in
                guard let symCourseModel = symCourseModel.first else { return }
                guard let rubSymCourse = self.symCourse else { return }
                guard let symUsdCourse = symCourseModel.rate.toDouble() else { return }
                self.dollarCourse = rubSymCourse / symUsdCourse
                
                self.userRubToUsdCounting()
                self.userCurrencyCounting()
            } errorClosure: {
                self.dollarCourse = nil

                self.userRubToUsdCounting()
                self.userCurrencyCounting()
            }

        default:
            break
        }
    }
    
    private func userRubToSymCounting() {
        if self.symCourse == nil {
            self.dollarResultLabel.text = UIStrings.error.rawValue
        } else {
            let symCount = (self.symCourse ?? 0) * (self.rublesTextField.text?.toDouble() ?? 1)
            self.symResultLabel.text = "\(symCount.roundForSignsAfterDot(1).toString()) \(UIStrings.cym.rawValue)"
        }
    }
    
    private func userRubToUsdCounting() {
        if self.dollarCourse == nil {
            self.dollarResultLabel.text = UIStrings.error.rawValue
        } else {
            let dollarCount = (self.dollarCourse ?? 0) * (self.rublesTextField.text?.toDouble() ?? 1)
            self.dollarResultLabel.text = "\(dollarCount.roundForSignsAfterDot(2).toString()) \(UIStrings.usd.rawValue)"
        }
    }
    
    private func userCurrencyCounting() {
        switch choosedCurrency {
        case .sym:
            guard let symCourse else {
                rubResultLabel.text = UIStrings.error.rawValue
                return
            }
            rubResultLabel.text = ((currencyTextField.text?.toDouble() ?? 1) / symCourse).roundForSignsAfterDot(2).toString() + " \(UIStrings.rub.rawValue)"
        case .usd:
            guard let dollarCourse else {
                rubResultLabel.text = UIStrings.error.rawValue
                return
            }
            rubResultLabel.text = ((currencyTextField.text?.toDouble() ?? 1) / dollarCourse).roundForSignsAfterDot(2).toString() + " \(UIStrings.rub.rawValue)"
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
    
    @objc private func settingsButtonAction() {
        let settingVC = SettingsController(nibName: SettingsController.id, bundle: nil)
        let settingNavVC = UINavigationController(rootViewController: settingVC)
        
        settingVC.beforeDissapearClosure = { [weak self] in
            guard let self else { return }
            self.symResultLabel.textColor = .label
            
            self.updateRates(date: self.datePicker.date)
        }
        
        present(settingNavVC, animated: true, completion: nil)
    }
    
    @IBAction func datePickerChangedAction(_ sender: Any) {
        updateRates(date: datePicker.date)
    }
    
    
}
