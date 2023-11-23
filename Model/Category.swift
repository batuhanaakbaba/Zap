//
//  Category.swift
//  Zap
//
//  Created by Batuhan Akbaba on 14.11.2023.
//

import Foundation
import FirebaseDatabase

class Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return true
    }
    
    var categoryId: String
    var categoryName: String
    var categoryImage: String
    var order: Int 

    init(categoryName: String, categoryImage: String) {
        self.categoryId = ""
        self.categoryName = categoryName
        self.categoryImage = categoryImage
        self.order = 0
    }
    
    init(categoryName: String, categoryImage: String, categoryId: String) {
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.categoryImage = categoryImage
        self.order = 0
    }

    init(dictionary: Dictionary<String, Any>) {
        categoryId = dictionary[kCategoryId] as! String
        categoryName = dictionary[kCategoryName] as! String
        categoryImage = dictionary[kCategoryImage] as! String
        order = dictionary[kOrder] as! Int
    }
}
//
//func saveCategoryToFirebase(category: Category) {
//    let id = shortUUID()
//    category.categoryId = id
//
//    Database.database(url: "https://zapapp-be479-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("Category").child(id).setValue(categoryDictionaryFrom(category: category) as! [String: Any])
//}
//
//func categoryDictionaryFrom(category: Category) -> NSDictionary {
//    return NSDictionary(objects: [category.categoryId,category.categoryName,category.categoryImage,category.order], forKeys: [kCategoryId as NSCopying,kCategoryName as NSCopying,kCategoryImage as NSCopying,kOrder as NSCopying])
//}
//
//func createCategorySet() {
//
//    let news = Category(categoryName: "News", categoryImage: "📰")
//    let ent = Category(categoryName: "Entertainment", categoryImage: "🎪")
//    let sprt = Category(categoryName: "Sport", categoryImage: "🏈")
//    let memes = Category(categoryName: "Memes", categoryImage: "💩")
//    let beaty = Category(categoryName: "Beauty", categoryImage: "💅")
//    let inth = Category(categoryName: "Internet Virals", categoryImage: "💥")
//    let tech = Category(categoryName: "Technology", categoryImage: "💻")
//    let fash = Category(categoryName: "Fashion", categoryImage: "👠")
//    let life = Category(categoryName: "Lifestyle", categoryImage: "🦄")
//    let startup = Category(categoryName: "Startups", categoryImage: "🚀")
//    let buss = Category(categoryName: "Business", categoryImage: "🏢")
//    let finance = Category(categoryName: "Finance", categoryImage: "💸")
//    let real = Category(categoryName: "Real Estates", categoryImage: "🏡")
//    let game = Category(categoryName: "Gaming", categoryImage: "🕹")
//    let science = Category(categoryName: "Science", categoryImage: "🧪")
//    let car = Category(categoryName: "Cars", categoryImage: "🚗")
//    let chris = Category(categoryName: "Christianity", categoryImage: "✝️")
//    let food = Category(categoryName: "Food", categoryImage: "🍕")
//    let animal = Category(categoryName: "Animals", categoryImage: "🐶")
//    let oddly = Category(categoryName: "Oddly Satisfying", categoryImage: "🫠")
//    let places = Category(categoryName: "Places", categoryImage: "📍")
//    let music = Category(categoryName: "Music", categoryImage: "🎸")
//    let archi = Category(categoryName: "Architecture", categoryImage: "🏰")
//    let travel = Category(categoryName: "Travel", categoryImage: "🏖️")
//    let diy = Category(categoryName: "DIY", categoryImage: "🛠️")
//    let art = Category(categoryName: "Art", categoryImage: "🎨")
//    let enginerr = Category(categoryName: "Engineering", categoryImage: "⚙️")
//    let funny = Category(categoryName: "Funny", categoryImage: "🤣️")
//    let interest = Category(categoryName: "Interesting", categoryImage: "🤯")
//    let college = Category(categoryName: "️College", categoryImage: "🎓")
//    let cringe = Category(categoryName: "Cringe", categoryImage: "🫣")
//    let celebr = Category(categoryName: "Celebrities", categoryImage: "🤩")
//    let personal = Category(categoryName: "Personel Growth", categoryImage: "🪞")
//    let shopp = Category(categoryName: "Shopping", categoryImage: "🛍️")
//    let asmr = Category(categoryName: "ASMR", categoryImage: "💆‍♀️")
//    let hots = Category(categoryName: "Hots", categoryImage: "🔥")
//    let tfh = Category(categoryName: "24h", categoryImage: "🌟")
//    let lm = Category(categoryName: "Last Month", categoryImage: "⏪")
//    let rndm = Category(categoryName: "Random", categoryImage: "🎲")
//    let dwu = Category(categoryName: "Daily Wrap Up", categoryImage: "")
//    let feeling = Category(categoryName: "Feeling nostalgic", categoryImage: "🕰️")
//    let need = Category(categoryName: "I need motivation", categoryImage: "✨")
//    let laugh = Category(categoryName: "Make me laugh", categoryImage: "🤣")
//    let thing = Category(categoryName: "Show me interesting things", categoryImage: "🤯")
//    let explore = Category(categoryName: "Let me explore beautiful places", categoryImage: "🏖️")
//    let moment = Category(categoryName: "Wholesome moments", categoryImage: "🥰")
//    let relax = Category(categoryName: "Relax", categoryImage: "🧘‍♀️")
//
//    let arraysOfCategories = [news,ent,sprt,memes,beaty,inth,tech,fash,life,startup,buss,finance,real,game,science,car,chris,food,animal,oddly,places,music,archi,travel,diy,art,enginerr,funny,interest,college,cringe,celebr,personal,shopp,asmr,hots,tfh,lm,rndm,dwu,feeling,need,laugh,thing,explore,moment,relax]
//
//    for (index, category) in arraysOfCategories.enumerated() {
//        let categoryId = "category_\(index)"
//        category.categoryId = categoryId
//
//        // Sıra numarasını kategoriye ekle
//        category.order = index
//
//        // Kategoriyi Firebase'e ekleyin
//        saveCategoryToFirebase(category: category)
//    }
//
//
//}
