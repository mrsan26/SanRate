//
//  HostingController.swift
//  Course Check
//
//  Created by Sanchez on 28.09.2023.
//

import Foundation
import SwiftUI
import CheesyChart

class HostingController: UIHostingController<CheesyChart> {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        let contentView = rootView
        self.rootView = contentView
    }
}
