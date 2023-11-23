//
//  ShareCell.swift
//  Zap
//
//  Created by Batuhan Akbaba on 13.11.2023.
//

import UIKit

class ShareCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    
    var category: Category? {
        didSet {
            configure()
        }
    }
    
    var isSelectedCategory: Bool = false {
        didSet {
            categoryView.backgroundColor = isSelectedCategory ? .white : UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
            categoryLabel.textColor = isSelectedCategory ? .black : .white
           
        }
    }
    
    func configure() {
        categoryLabel.text = category?.categoryName
      
    }
    
   
}
