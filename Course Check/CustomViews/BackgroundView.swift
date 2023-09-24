//
//  BackgroundView.swift
//  Course Check
//
//  Created by Sanchez on 22.09.2023.
//

import Foundation
import UIKit

class BackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .systemGray6
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2.0
    }
    
}
