//
//  MovieViewController.swift
//  Cinema
//
//  Created by Water Su on 2018/8/12.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class MovieViewController: UIViewController {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.text = "lbl_common_title".localized
        }
    }
    @IBOutlet weak var detailLabel: UILabel!{
        didSet{
            detailLabel.text = "lbl_common_language".localized
        }
    }
    @IBOutlet weak var overviewText: UITextView!{
        didSet{
            overviewText.text = "lbl_common_overview".localized
        }
    }
    @IBOutlet weak var actionBtn: UIButton!{
        didSet{
            actionBtn.setTitle("btn_book_now".localized, for: .normal)
        }
    }
    
    private var bookingPath: String?
    
    private var movieId: String?
    
    private var moviePip = PublishSubject<Movie>()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        self.moviePip.subscribe(onNext: { (movie) in
            self.bind(movie)
        }).disposed(by: disposeBag)
        
        requestAPI(self.movieId)
    }
    
    func bind(movieId : String?){
        self.movieId = movieId
        DebugUtil.log(level: .Info, domain: .UI, message: "open movie \(movieId ?? "")")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func requestAPI(_ id: String?) {
        guard let movieId = id else {return}
        APIManager
            .getMovie(id: movieId)
            .subscribe(onNext: { [weak self] (response, json) in
//                DebugUtil.log(level: .Info, domain: .UI, message: "\(json)")
                if let data = json as? [String : Any]{
                    let movie = Movie(data: data)
                    self?.moviePip.onNext(movie)
                }
            }).disposed(by: disposeBag)
    }

    func bind(_ movie : Movie?) {
        guard let movie = movie else {return}
        // handle UI display
        self.titleLabel.text = movie.title
        self.overviewText.text = movie.overview
        self.detailLabel.text = movie.displayDetail()
        self.bookingPath = movie.bookingPage
        
        self.actionBtn.isHidden = self.bookingPath == nil ? true : false
        
        if let url = ImageUtil.posterUrl(path: movie.poster_path){
            poster.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }else{
            poster.image = nil
        }
        if let bgUrl = ImageUtil.backdropUrl(path: movie.backdrop_path){
            bgImage.sd_setImage(with: bgUrl, placeholderImage: UIImage(named: "placeholder"))
        }else{
            bgImage.image = nil
        }
    }
    @IBAction func didClickBookNow(_ sender: Any) {
        // open url
        guard let path = self.bookingPath else {return}
        if let url = URL(string: path){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
