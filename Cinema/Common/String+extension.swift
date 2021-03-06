//
//  String+extension.swift
//  Cinema
//
//  Created by Water Su on 2018/8/9.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import Foundation

extension String{
    
    var localized: String{
        return NSLocalizedString(self, comment: "")
    }
    
}
extension Date{
    func toString(format: String = "yyyy-MM-dd") -> String{
        let fmt = DateFormatter()
        fmt.dateFormat = format
        return fmt.string(from: self)
    }
}
