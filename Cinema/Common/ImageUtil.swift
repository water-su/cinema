//
//  ImageUtil.swift
//  Cinema
//
//  Created by Water Su on 2018/8/6.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit

/*
 TMDB image configuration Spec
 https://developers.themoviedb.org/3/configuration/get-api-configuration
 */
// https://image.tmdb.org/t/p/w92/guzErWtMwIQVIbgsopD88iTTtrO.jpg
class ImageUtil: NSObject {

    private static let baseUrl = "https://image.tmdb.org/t/p/"
    class func posterUrl(path: String?) -> URL?{
        guard let path = path else {return nil}
        return URL(string: baseUrl+"w500/"+path)
    }
    class func backdropUrl(path: String?) -> URL?{
        guard let path = path else {return nil}
        return URL(string: baseUrl+"w780/"+path)
    }
}

/*
 {
 "images": {
 "base_url": "http://image.tmdb.org/t/p/",
 "secure_base_url": "https://image.tmdb.org/t/p/",
 "backdrop_sizes": [
 "w300",
 "w780",
 "w1280",
 "original"
 ],
 "logo_sizes": [
 "w45",
 "w92",
 "w154",
 "w185",
 "w300",
 "w500",
 "original"
 ],
 "poster_sizes": [
 "w92",
 "w154",
 "w185",
 "w342",
 "w500",
 "w780",
 "original"
 ],
 "profile_sizes": [
 "w45",
 "w185",
 "h632",
 "original"
 ],
 "still_sizes": [
 "w92",
 "w185",
 "w300",
 "original"
 ]
 },
 "change_keys": [
 "adult",
 "air_date",
 "also_known_as",
 "alternative_titles",
 "biography",
 "birthday",
 "budget",
 "cast",
 "certifications",
 "character_names",
 "created_by",
 "crew",
 "deathday",
 "episode",
 "episode_number",
 "episode_run_time",
 "freebase_id",
 "freebase_mid",
 "general",
 "genres",
 "guest_stars",
 "homepage",
 "images",
 "imdb_id",
 "languages",
 "name",
 "network",
 "origin_country",
 "original_name",
 "original_title",
 "overview",
 "parts",
 "place_of_birth",
 "plot_keywords",
 "production_code",
 "production_companies",
 "production_countries",
 "releases",
 "revenue",
 "runtime",
 "season",
 "season_number",
 "season_regular",
 "spoken_languages",
 "status",
 "tagline",
 "title",
 "translations",
 "tvdb_id",
 "tvrage_id",
 "type",
 "video",
 "videos"
 ]
 }
 */
