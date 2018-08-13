//
//  DebugUtil.swift
//  Cinema
//
//  Created by Water Su on 2018/8/6.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit

class DebugUtil: NSObject {
    
    enum Level : String{
        case Info
        case Warning
        case Error
    }
    enum Domain : String{
        case API
        case UI
        case Base
    }
    static func log(level: Level, domain: Domain, message: String){
        print("\(level.rawValue): \(domain) - \(message)")
        // TODO: also send to fabric
    }
}
