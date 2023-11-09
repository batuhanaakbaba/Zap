//
//  MoodWatchCollectionViewCell.swift
//  Zap
//
//  Created by Batuhan Akbaba on 30.10.2023.
//

import UIKit

class MoodWatchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    func configure(with categoryName: String) {
        categoryLabel.text = categoryName
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
        categoryView.layer.borderWidth = 1.0
        categoryView.layer.cornerRadius = 20
    }
}
