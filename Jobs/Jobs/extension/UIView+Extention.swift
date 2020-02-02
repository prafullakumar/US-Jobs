//
//  UIView+Extention.swift
//  Jobs
//
//  Created by prafull kumar on 2/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import UIKit

extension UIView {
    func bindFrameTo(view:UIView, padding: CGFloat = 0) {
           self.translatesAutoresizingMaskIntoConstraints = false
           self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
           self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1 * padding).isActive = true
           self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
           self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1 * padding).isActive = true
           
       }
}
