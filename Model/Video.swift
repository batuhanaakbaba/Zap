//
//  Video.swift
//  Zap
//
//  Created by Batuhan Akbaba on 21.11.2023.
//

import Foundation

class Video {
    var credit: String?
    var videoId: String?
    var videoURL: String?
    var url: String?
    var socialMedia: String?
    var description: String?
    var date: Int?
    var likeCount: Int?
    var commentCount: Int?
    var bookmarkCount: Int?
    var views: Int?
    var categoryIds: [String]?

    static func transformVideo(dictionary: Dictionary<String, Any>, key: String) -> Video {
        let video = Video()
        video.videoId = key
        video.credit = dictionary["credit"] as? String
        video.videoURL = dictionary["videoURL"] as? String
        video.url = dictionary["url"] as? String
        video.socialMedia = dictionary["socialMedia"] as? String
        video.description = dictionary["description"] as? String
        video.date = dictionary["date"] as? Int
        video.likeCount = dictionary["likeCount"] as? Int
        video.commentCount = dictionary["commentCount"] as? Int
        video.bookmarkCount = dictionary["bookmarkCount"] as? Int
        video.views = dictionary["views"] as? Int
        video.categoryIds = dictionary["categories"] as? [String]
        return video
    }
}
