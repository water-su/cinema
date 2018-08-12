//
//  UIView+extension.swift
//  Cinema
//
//  Created by Water Su on 2018/8/12.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit

extension UIView {
    
    func fit(_ view: UIView){
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }

}
