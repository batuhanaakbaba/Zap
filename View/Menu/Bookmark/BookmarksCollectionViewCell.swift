//
//  BookmarksCollectionViewCell.swift
//  Zap
//
//  Created by Batuhan Akbaba on 27.10.2023.
//

import UIKit

class BookmarksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookmarksImage: UIImageView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var highlightsView: UIView!
    
    
    override var isHighlighted: Bool {
      didSet {
        highlightsView.isHidden = !isHighlighted
      }
    }
    
    override var isSelected: Bool {
      didSet {
        highlightsView.isHidden = !isSelected
        selectedImage.isHidden = !isSelected
      }
    }
    
    override func awakeFromNib() {
          super.awakeFromNib()
        highlightsView.isHidden = true
        selectedImage.isHidden = true
      }
    
    
}
