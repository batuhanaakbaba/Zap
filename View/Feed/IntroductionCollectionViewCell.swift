//
//  FeedCollectionViewCell.swift
//  Zap
//
//  Created by Batuhan Akbaba on 31.10.2023.
//

import UIKit
import Lottie

class IntroductionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var zapTeamButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var animationView: LottieAnimationView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        zapTeamButton.contentHorizontalAlignment = .left
    }

    func animationCell(indexPath: IndexPath) {
        if indexPath.row == 0 {
           
            let animation = LottieAnimation.named("Animation - 1698999264201")
            animationView = LottieAnimationView(animation: animation)
            animationView?.frame = self.contentView.bounds
            animationView?.contentMode = .scaleAspectFit
            animationView?.loopMode = .playOnce
            animationView?.animationSpeed = 1
            self.contentView.addSubview(animationView!)
            animationView?.play()

            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                self.animationView?.removeFromSuperview()
                self.animationView = nil
            }
            
        } else {
            animationView?.removeFromSuperview()
            animationView = nil
        }
    }

    func configure(with introduction: String, description: String, color: UIColor, tintColor: UIColor) {
        introductionLabel.text = introduction
        descriptionLabel.text = description
        backgroundColor = color
       
        [introductionLabel,descriptionLabel,welcomeLabel].forEach { label in
            label?.textColor = tintColor
        }
        zapTeamButton.setTitleColor(tintColor, for: .normal)
        
        buttonsTintColor(imageName: "heart-image", color: tintColor, button: likeButton)
        buttonsTintColor(imageName: "comment-image", color: tintColor, button: commentButton)
        buttonsTintColor(imageName: "bookmark-image", color: tintColor, button: bookmarkButton)
        buttonsTintColor(imageName: "share-image", color: tintColor, button: shareButton)
    }
    
 
    func buttonsTintColor(imageName: String, color: UIColor, button: UIButton) {
        let image = UIImage(named: imageName)!
        let tintedImage = image.withTintColor(color, renderingMode: .alwaysOriginal)
        button.setImage(tintedImage, for: .normal)
    }
    
}
