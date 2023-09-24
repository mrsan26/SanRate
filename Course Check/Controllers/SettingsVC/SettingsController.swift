//
//  SettingsController.swift
//  Course Check
//
//  Created by Sanchez on 24.09.2023.
//

import UIKit

class SettingsController: UIViewController {

    static let id = String(describing: SettingsController.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        setupUI()
    }
    
    private func setupUI() {
        let doneTopBarButton = UIBarButtonItem(title: " Готово", style: .plain, target: self, action: #selector(clouseAction))
        navigationItem.rightBarButtonItem = doneTopBarButton
    }
    
    @objc private func clouseAction() {
        dismiss(animated: true)
    }
}
