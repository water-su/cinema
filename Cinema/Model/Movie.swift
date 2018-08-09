//
//  Movie.swift
//  Cinema
//
//  Created by Water Su on 2018/8/6.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit
/*
{
    adult = 0;
    "backdrop_path" = "/guzErWtMwIQVIbgsopD88iTTtrO.jpg";
    "genre_ids" =             (
        35
    );
    id = 528261;
    "original_language" = de;
    "original_title" = "Hilflos in Weissensee, es kann jeden treffen!";
    overview = "Edeltraut celebrating into her birthday. But the next morning is not a picnic.";
    popularity = "0.07099999999999999";
    "poster_path" = "/fuEx8J4JtdgzVFdp8dVnwqlKnlu.jpg";
    "release_date" = "2016-12-31";
    title = "HELPLESS IN WEISSENSEE, It can happen to anyone!";
    video = 0;
    "vote_average" = 10;
    "vote_count" = 1;
}
*/
class Movie: NSObject {
    
    var id : Int64 = 0
    var title : String?
    var overview : String?
    var backdrop_path : String?
    var poster_path : String?
    var adult : Int = 0
//    var genre_ids
    var original_language : String?
    var original_title : String?
    var popularity : Double = 0
    var release_date : String?
    var video : Int = 0
    var vote_average : Int = 0
    var vote_count : Int = 0
    
    lazy var popularityDisplayString = String(format: "%@ : %.2f", "lbl_common_popularity".localized , self.popularity)
    
    init(data: [String:Any]) {
        for key in data.keys{
            switch key{
            case "id":
                self.id = data[key] as? Int64 ?? 0
                
            case "title":
                self.title = data[key] as? String
            case "overview":
                self.overview = data[key] as? String
            case "backdrop_path":
                self.backdrop_path = data[key] as? String
            case "poster_path":
                self.poster_path = data[key] as? String
                
            case "original_language":
                self.original_language = data[key] as? String
            case "original_title":
                self.original_title = data[key] as? String
                
            case "adult":
                self.adult = data[key] as? Int ?? 0
            case "popularity":
                self.popularity = data[key] as? Double ?? 0
            case "release_date":
                self.release_date = data[key] as? String
            case "video":
                self.video = data[key] as? Int ?? 0
                
            case "vote_average":
                self.vote_average = data[key] as? Int ?? 0
            case "vote_count":
                self.vote_count = data[key] as? Int ?? 0
                
//            case "genre_ids":
            default:
                DebugUtil.log(level: .Info, domain: .API, message: "unused key \(key)")
            }
        }
    }

}
