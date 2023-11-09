//
//  CategoryCollectionViewCell.swift
//  Zap
//
//  Created by Batuhan Akbaba on 21.10.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryImage: UILabel!
    
    
    var isSelectedCategory: Bool = false {
        didSet {
            categoryView.backgroundColor = isSelectedCategory ? .white : UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
            categoryLabel.textColor = isSelectedCategory ? .black : .white
        }
    }
    
    func configure(with categoryName: String, categoryImageName: String) {
        categoryLabel.text = categoryName
        categoryImage.text = categoryImageName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryLabel.textColor = .white
    }
}
