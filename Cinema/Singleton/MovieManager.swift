//
//  MovieManager.swift
//  Cinema
//
//  Created by Water Su on 2018/8/6.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit

class MovieManager: NSObject {
    static let shared = MovieManager()
    
    func parse(data: [[String: Any]]) -> [Movie] {
        return data.map{ Movie(data: $0) }
    }
}
