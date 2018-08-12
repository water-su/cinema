//
//  EmptyView.swift
//  Cinema
//
//  Created by Water Su on 2018/8/11.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit


class EmptyView: UIView {

    enum ViewType {
        case MovieList
        // TODO: add other type of empty view here
        
        var title: String{
            switch self{
            case .MovieList:
                return "lbl_empty_message".localized
            }
        }
        // TODO: add other parameter here (ex: image name)
        // according to empty view UI design
    }
    
    class func loadFromXib() -> EmptyView?{
        let view = Bundle.main.loadNibNamed("EmptyView", owner: nil, options: nil)?.first as? EmptyView
        view?.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    @IBOutlet weak var titleLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func bind(type: ViewType){
        self.titleLabel.text = type.title
        // TODO: configure for other parameter of empty view (ex: image)
    }
    
    
}
