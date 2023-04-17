//
//  Movie.swift
//  NetFlixClone
//
//  Created by 김예림 on 2023/04/12.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_language: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}


/* {
 adult = 0;
 "backdrop_path" = "/wybmSmviUXxlBmX44gtpow5Y9TB.jpg";
 "genre_ids" =             (
     28,
     35,
     14
 );
 id = 594767;
 "media_type" = movie;
 "original_language" = en;
 "original_title" = "Shazam! Fury of the Gods";
 overview = "Billy Batson and his foster siblings, who transform into superheroes by saying \"Shazam!\", are forced to get back into action and fight the Daughters of Atlas, who they must stop from using a weapon that could destroy the world.";
 popularity = "4162.423";
 "poster_path" = "/A3ZbZsmsvNGdprRi2lKgGEeVLEH.jpg";
 "release_date" = "2023-03-15";
 title = "Shazam! Fury of the Gods";
 video = 0;
 "vote_average" = "6.974";
 "vote_count" = 700;
}*/
