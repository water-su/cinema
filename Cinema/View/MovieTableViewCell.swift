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

    @IBOutlet weak var mBgImage: UIImageView!
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!{
        didSet{
            detailLabel.text = "lbl_common_title".localized
        }
    }
    @IBOutlet weak var descLabel: UILabel!{
        didSet{
            descLabel.text = nil
        }
    }
    @IBOutlet weak var timeLabel: UILabel!{
        didSet{
            timeLabel.text = nil
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(movie: Movie?){
        guard let movie = movie else {
            // handle error
            detailLabel.text = "lbl_common_error_msg".localized
            return
        }
        mImageView.sd_cancelCurrentImageLoad()
        if let url = ImageUtil.posterUrl(path: movie.poster_path){
            mImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }else{
            mImageView.image = nil
        }
        mBgImage.sd_cancelCurrentImageLoad()
        if let bgUrl = ImageUtil.backdropUrl(path: movie.backdrop_path){
            mBgImage.sd_setImage(with: bgUrl, placeholderImage: UIImage(named: "placeholder"))
        }else{
            mBgImage.image = nil
        }
        detailLabel.text = movie.title
        descLabel.text = movie.overview
        timeLabel.text = movie.popularityDisplayString
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        detailLabel.text = nil
        descLabel.text = nil
        timeLabel.text = nil
    }
}
