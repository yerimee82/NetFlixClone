//
//  YoutubeSearchResults.swift
//  NetFlixClone
//
//  Created by 김예림 on 2023/04/18.
//

import Foundation

/*
 items =     (
             {
         etag = bQHwflIZs0ARy85b65shLkKsdtU;
         id =             {
             kind = "youtube#video";
             videoId = "GP32pkR7-to";
         };
         kind = "youtube#searchResult";
     },
 */

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
