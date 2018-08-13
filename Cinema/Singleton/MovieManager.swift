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
    
    private override init(){}
    
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
    
    func requestMovies() -> Observable<[String]>{
        MovieManager.shared.reset()
        var nextPage = 1    // will capture nextPage to keep request go on
        return Observable.create({ observer -> Disposable in
            APIManager.getMovieList(page: nextPage)
                .subscribe(onNext: { (response, json) in
                    guard let json = json as? [String : Any] else {
                        // handle format error
                        DebugUtil.log(level: .Error, domain: .API, message: "got incorrect format from getMovieList API")
                        return
                    }
                    
                    var newMovies = [String]()
                    if let datas = json["results"] as? [[String: Any]]{
                        newMovies = datas.flatMap{
                            MovieManager.shared.appendMovie( Movie(data: $0) )
                        }
                    }
                    if let page = json["page"] as? Int{
                        DebugUtil.log(level: .Info, domain: .API, message: "got page \(nextPage)")
                        nextPage = page + 1
                    }
                    observer.onNext( newMovies )
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func reset(){
        self.moviePool = [:]
    }
    
    func getMovie(id: String?) -> Movie?{
        guard let id = id else {return nil}
        return self.moviePool[id]
    }
}
