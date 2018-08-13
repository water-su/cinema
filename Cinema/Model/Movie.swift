//
//  Movie.swift
//  Cinema
//
//  Created by Water Su on 2018/8/6.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit
/*  in list
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
/* full data
 {
 adult = 0;
 "backdrop_path" = "<null>";
 "belongs_to_collection" = "<null>";
 budget = 0;
 genres =     (
 {
 id = 28;
 name = Action;
 },
 {
 id = 12;
 name = Adventure;
 },
 {
 id = 18;
 name = Drama;
 },
 {
 id = 10752;
 name = War;
 }
 );
 homepage = "<null>";
 id = 49046;
 "imdb_id" = tt1016150;
 "original_language" = en;
 "original_title" = "All Quiet on the Western Front";
 overview = "A young German soldier's terrifying experiences and distress on the western front during World War I.";
 popularity = "3.906";
 "poster_path" = "/jZWVtbxyztDTSM0LXDcE6vdVTVC.jpg";
 "production_companies" =     (
 );
 "production_countries" =     (
 );
 "release_date" = "2018-12-31";
 revenue = 0;
 runtime = "<null>";
 "spoken_languages" =     (
 {
 "iso_639_1" = en;
 name = English;
 }
 );
 status = Planned;
 tagline = "";
 title = "All Quiet on the Western Front";
 video = 0;
 "vote_average" = 0;
 "vote_count" = 2;
 }
 */
class Movie: NSObject {
    
    var id : String?
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
    
    var genres : [[String : Any]]?
    var spoken_language : [[String : Any]]?
    var runtime : Int = 0
    
    lazy var popularityDisplayString = String(format: "%@ - %@ : %.2f", self.release_date ?? "", "lbl_common_popularity".localized , self.popularity)
    
    init(data: [String:Any]) {
        for key in data.keys{
            switch key{
            case "id":
                if let value = data[key] as? Int64{
                    self.id = String(value)
                }
                
            case "title":
                self.title = data[key] as? String
            case "overview": // synopsis
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
            case "genre_ids":
                break // skipped
                
            // from full data
            case "genres":  // dict
                self.genres = data[key] as? [[String : Any]]
            case "spoken_languages": // dict
                self.spoken_language = data[key] as? [[String : Any]]
            case "runtime":
                self.runtime = data[key] as? Int ?? 0
                DebugUtil.log(level: .Info, domain: .API, message: "got time \(self.runtime)")
            default:
//                DebugUtil.log(level: .Info, domain: .API, message: "unused key \(key)")
                break
            }
        }
    }
    func getLanguage() -> String? {
        return self.extract(form: self.spoken_language, key: "name")
    }
    func getGenres() -> String? {
        return self.extract(form: self.genres, key: "name")
    }
    func getDuration() -> String? {
        return self.runtime > 0 ? "\(self.runtime) \("lbl_common_minutes".localized)" : nil
    }

    private func extract(form data: [[String:Any]]?, key : String) -> String?{
        guard let data = data else {return nil}
        let result = data
            .map({ (genres) -> String? in
                return genres["name"] as? String
            })
            .flatMap{$0}
            .joined(separator: ", ")
        return result.count > 0 ? result : nil
    }
    
    func displayDetail() -> String?{
        let data = [("lbl_common_language"  , self.getLanguage()),
                    ("lbl_common_genres"    , self.getGenres()),
                    ("lbl_common_duration"  , self.getDuration())]
        let result = data
            .flatMap { (arg) -> (String, String)? in
                return arg.1 != nil ? (arg.0, arg.1!) : nil
            }.map { (arg) -> String in
                return arg.0.localized + ": " + arg.1
            }.joined(separator: "\n")
        return result
    }
}
