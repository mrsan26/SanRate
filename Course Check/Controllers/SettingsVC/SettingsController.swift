//
//  SettingsController.swift
//  Course Check
//
//  Created by Sanchez on 24.09.2023.
//

import UIKit

class SettingsController: UIViewController {

    static let id = String(describing: SettingsController.self)
    
    var beforeDissapearClosure: (() -> Void)?
    
    @IBOutlet weak var userSymRateTextField: UITextField!
    @IBOutlet weak var usdRateModeSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        title = "Настройки"
        setupUI()
        
        userSymRateTextField.addTarget(self, action: #selector(updateUserSymRate), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        beforeDissapearClosure?()
    }
    
    private func setupUI() {
        let doneTopBarButton = UIBarButtonItem(title: " Готово", style: .plain, target: self, action: #selector(clouseAction))
        navigationItem.rightBarButtonItem = doneTopBarButton
        
        userSymRateTextField.text = (UserManager.read(.userSymRate) as Double?)?.toString()
        usdRateModeSegment.selectedSegmentIndex = UserManager.read(.usdMode) ?? 0
    }
    
    @objc private func updateUserSymRate() {
        userSymRateTextField.text = userSymRateTextField.text?.replacingOccurrences(of: ",", with: ".")
        guard let userText = userSymRateTextField.text else { return }
        if let userTextInt = userText.toDouble() {
            UserManager.write(value: userTextInt, for: .userSymRate)
        } else {
            UserManager.remove(.userSymRate)
        }
    }
    
    @IBAction func updateUsdMode(_ sender: Any) {
        UserManager.write(value: usdRateModeSegment.selectedSegmentIndex, for: .usdMode)
    }
    
    @objc private func clouseAction() {
        dismiss(animated: true)
    }
}
