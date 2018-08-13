//
//  Secrets.swift
//  Cinema
//
//  Created by Water Su on 2018/8/13.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import Foundation

class Secrets : NSObject{
    
    enum Key : String{
        case APIKey
        // TODO: add other secrets
        
        var path : String {
            switch self {
            case .APIKey:
                return "APIKey"
            }
        }
    }
    
    static let shared = Secrets()
    
    private lazy var dict : NSDictionary = {
        if let path = Bundle.main.path(forResource: "Secret", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path){
            // Use your myDict here
            return dict
        }else{
            let msg = "Must have secret file"
            DebugUtil.log(level: .Error, domain: .Base, message: msg)
            assert(false, msg)
        }
    }()
    
    func getSecret(for key : Key) -> String?{
        if let value = self.dict.object(forKey: key.path) as? String{
            return value
        }else{
            let msg = "Request invalid api key \(key.rawValue)"
            DebugUtil.log(level: .Error, domain: .Base, message: msg)
            assert(false, msg)
        }
        return nil
    }
}
