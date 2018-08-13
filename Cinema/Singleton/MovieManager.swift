//
//  MovieManager.swift
//  Cinema
//
//  Created by Water Su on 2018/8/6.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit
import RxSwift

class MovieManager: NSObject {
    
    static let shared = MovieManager()
    
    private override init(){
        super.init()
        requestToggle
            .map({ (reset) in return reset ? 0 : self.currentPage + 1 })
            .distinctUntilChanged() // prevent get same page multiple times
            .subscribe(onNext: { [weak self] (page) in
                APIManager.getMovieList(page: page)
                    .subscribe(onNext: { [weak self] (response, json) in
                        guard let json = json as? [String : Any] else {
                            // handle format error
                            DebugUtil.log(level: .Error, domain: .API, message: "got incorrect format from getMovieList API")
                            return
                        }
                        
                        var newMovies = [String]()
                        if let datas = json["results"] as? [[String: Any]]{
                            newMovies = datas.flatMap{
                                self?.appendMovie( Movie(data: $0) )
                            }
                        }
                        if let page = json["page"] as? Int{
                            DebugUtil.log(level: .Info, domain: .API, message: "got page \(page)")
                            self?.currentPage = page
                        }
                        self?.moviesPip.onNext(newMovies)
                    }).disposed(by: self!.disposeBag)
                
            }).disposed(by: disposeBag)
    }
    
    private var currentPage = 0
    
    var requestToggle = PublishSubject<Bool>()
    
    var moviesPip = PublishSubject<[String]>()
    
    private let disposeBag = DisposeBag()
    
    private var moviePool = [String : Movie]()

    private func appendMovie(_ movie: Movie?) -> String?{
        guard let movie = movie else {return nil}
        guard let id = movie.id else {return nil}
        var added : String?
        if moviePool[id] == nil{
            added = id
        }else{
            DebugUtil.log(level: .Info, domain: .API, message: "skip duplicate : \(id)")
        }
        moviePool[id] = movie
        return added
    }
    
    func reset(){
        self.moviePool = [:]
        self.currentPage = 0
        self.requestToggle.onNext(true)
    }
    
    func getMovie(id: String?) -> Movie?{
        guard let id = id else {return nil}
        return self.moviePool[id]
    }
}
