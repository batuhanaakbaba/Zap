//
//  Constants.swift
//  Zap
//
//  Created by Batuhan Akbaba on 14.11.2023.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

public let kCategoryId = "categoryId"
public let kCategoryName = "categoryName"
public let kCategoryImage = "categoryImage"
public let kOrder = "order"

public let categoryDatabase = Database.database().reference().child("Category")
public let videosDatabase = Database.database().reference().child("Videos")
public let categoryVideosDatabase = Database.database().reference().child("Category-Videos")

public func shortUUID() -> String {
    let uuid = UUID().uuidString
    let shortUUID = uuid.prefix(10)
    return String(shortUUID)
}



