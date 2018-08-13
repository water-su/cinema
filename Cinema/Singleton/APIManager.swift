//
//  APIManager.swift
//  Cinema
//
//  Created by Water Su on 2018/8/6.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit
import Alamofire
import RxAlamofire
import RxSwift


class APIManager: NSObject {
    
    private static let urlBase = "https://api.themoviedb.org"
    private static var APIKey = ""

    enum APIPath {
        case movieList
        case movie
        
        var path : String{
            var result = ""
            switch self {
            case .movieList:
                result = "/3/discover/movie"
            case .movie:
                result = "/3/movie/%@"
            }
            return urlBase+result
        }
    }
    override init() {
        APIManager.APIKey = Secrets.shared.getSecret(for: .APIKey) ?? ""
    }
//    http://api.themoviedb.org/3/discover/movie?
//    api_key=328c283cd27bd1877d9080ccb1604c91
//    &primary_release_date.lte=2016-12-31
//    &sort_by=release_date.desc
//    &page=1
    
    class func getMovieList(page: Int) -> Observable<(HTTPURLResponse, Any)>{
        let param : [String : Any] = ["api_key" : APIKey,
                                      "primary_release_date.lte" : "2016-12-31",
                                      "sort_by" : "release_date.desc",
                                      "page" : page]
        return RxAlamofire.requestJSON(.get, APIPath.movieList.path, parameters: param, encoding: URLEncoding.default, headers: nil)
    }
    
//    API Doc: https://developers.themoviedb.org/3/movies/get-movie-details
//    http://api.themoviedb.org/3/movie/328111?
//    api_key=328c283cd27bd1877d9080ccb1604c91
    
    class func getMovie(id: String) -> Observable<(HTTPURLResponse, Any)>{
        let param = ["api_key": APIKey]
        let path = String(format: APIPath.movie.path, id)
        return RxAlamofire.requestJSON(.get, path , parameters: param, encoding: URLEncoding.default, headers: nil)
    }
    
}
