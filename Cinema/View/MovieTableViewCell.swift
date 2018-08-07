//
//  MovieTableViewCell.swift
//  Cinema
//
//  Created by Water Su on 2018/8/6.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(movie: Movie?){
        guard let movie = movie else {return}
        if let path = ImageUtil.posterUrl(path: movie.poster_path), let url = URL(string: path){
            mImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        titleLabel.text = movie.title
        descLabel.text = movie.overview
        timeLabel.text = movie.release_date
    }
}
