//
//  FeedCollectionViewCell.swift
//  Zap
//
//  Created by Batuhan Akbaba on 1.11.2023.
//

import UIKit
import Lottie
import SnapKit
import AVKit

class FeedCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var creditButton: UIButton!
    @IBOutlet weak var socialMediaImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var videoPlayerView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var bookmarkCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    private lazy var progressBar: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(), for: .normal)
        slider.minimumTrackTintColor = .white
        slider.addTarget(self, action: #selector(onTapToSlider), for: .valueChanged)
        return slider
    }()
    
    private lazy var currentDuration: UILabel = {
        let label = UILabel()
        label.text = "00:12"
        label.font = UIFont(name: "MavenPro-Medium", size: 12)
        label.textColor = .white
        return label
    }()
    
    private lazy var totalDuration: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MavenPro-Medium", size: 12)
        label.textColor = .white
        label.text = " / 00:40"
        return label
    }()
    private var isLikeButtonSelected = false
    private var isPlayPauseButtonSelected = false
    private var animationView: LottieAnimationView?
    
    private var player: AVPlayer? = nil
    private var playerLayer: AVPlayerLayer? = nil
    
    private var timeObserver: Any? = nil
    private var isThumbSeek: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        creditButton.contentHorizontalAlignment = .left
        buttonsTintColor(imageName: "heart-image", button: likeButton, tintColor: .white)
        buttonsTintColor(imageName: "comment-image", button: commentButton, tintColor: .white)
        buttonsTintColor(imageName: "bookmark-image", button: bookmarkButton, tintColor: .white)
        buttonsTintColor(imageName: "share-image", button: shareButton, tintColor: .white)
        setupUI()
        statusOfInitialOutlets()
        likeButtonActions()
        playPauseActions()
        oneClickAction()
  
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoPlayerView.bounds
    }
    func videoPlayer(videoUrl: String) {
        guard let url = URL(string: videoUrl) else {return}
        
        if self.player == nil {
            self.player = AVPlayer(url: url)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.videoGravity = .resizeAspectFill
            self.playerLayer?.frame = self.videoPlayerView.bounds
            if let playerLayer = self.playerLayer {
                self.videoPlayerView.layer.addSublayer(playerLayer)
            }
            self.player?.play()
        }
        self.setObserverToPlayer()
    }
    private func buttonsTintColor(imageName: String, button: UIButton, tintColor: UIColor) {
        let image = UIImage(named: imageName)!
        let tintedImage = image.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        button.setImage(tintedImage, for: .normal)
    }

    private func oneClickAction() {
        let oneTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedViewOneClick))
        oneTapGestureRecognizer.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(oneTapGestureRecognizer)
    }

    private func likeButtonActions() {
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleLikeButtonTapped))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGestureRecognizer)
        likeButton.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
    }
    @objc private func handleLikeButtonTapped() {
        isLikeButtonSelected.toggle()
        let imageName = isLikeButtonSelected ? "red-heart-image" : "heart-image"
        let tintColor = isLikeButtonSelected ? .red : UIColor.white
        buttonsTintColor(imageName: imageName, button: likeButton, tintColor: tintColor)
        if isLikeButtonSelected {
            if animationView == nil {
                let animation = LottieAnimation.named("8V3LtN2nLh")
                animationView = LottieAnimationView(animation: animation)
                animationView?.frame = self.contentView.bounds
                animationView?.contentMode = .scaleAspectFit
                animationView?.loopMode = .playOnce
                animationView?.animationSpeed = 1
                self.contentView.addSubview(animationView!)
                self.animationView?.play()
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2) {
                        self.likeCountLabel.isHidden = false
                        self.commentCountLabel.isHidden = false
                        self.bookmarkCountLabel.isHidden = false
                    }
                }

                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                    self.animationView?.removeFromSuperview()
                    self.animationView = nil
                }
            }
        }
    }


    @objc func didTappedViewOneClick() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.buttonsStackView.alpha = self.buttonsStackView.isHidden ? 1 : 0
                self.totalDuration.alpha = self.totalDuration.isHidden ? 1 : 0
                self.currentDuration.alpha = self.currentDuration.isHidden ? 1 : 0
                self.playPauseButton.alpha = self.playPauseButton.isHidden ? 1 : 0
                self.progressBar.alpha = self.progressBar.isHidden ? 1 : 0
            } completion: { _ in
                self.buttonsStackView.isHidden.toggle()
                self.totalDuration.isHidden = !self.buttonsStackView.isHidden
                self.currentDuration.isHidden = !self.buttonsStackView.isHidden
                self.playPauseButton.isHidden = !self.buttonsStackView.isHidden
                self.progressBar.isHidden = !self.buttonsStackView.isHidden
            }
        }
 
    }


 
    private func playPauseActions() {
        playPauseButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonDidTapped), for: .touchUpInside)

    }
    private func setupUI() {
        contentView.addSubview(currentDuration)
        currentDuration.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.equalTo(20)
        }

        contentView.addSubview(totalDuration)
        totalDuration.snp.makeConstraints { make in
            make.leading.equalTo(currentDuration.snp.trailing).offset(2)
            make.centerY.equalTo(currentDuration)
        }
        contentView.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(currentDuration.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-19)
        }
        containerView.frame = CGRect(x: 0, y: 0, width: 393, height: 188)
        let layer0 = CAGradientLayer()
        layer0.colors = [
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.19).cgColor,
        UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
         ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: -1, c: 1, d: 0, tx: 0, ty: 1))
        layer0.bounds = containerView.bounds.insetBy(dx: -containerView.bounds.size.width, dy: -containerView.bounds.size.height)
        layer0.position = containerView.center
        containerView.layer.addSublayer(layer0)
        topContainerView.frame = CGRect(x: 0, y: 0, width: 393, height: 188)
        let layer1 = CAGradientLayer()
        layer1.colors = [
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.19).cgColor,
        UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
         ]
        layer1.locations = [0, 1]
        layer1.endPoint = CGPoint(x: 0.25, y: 0.5)
        layer1.startPoint = CGPoint(x: 0.75, y: 0.5)
        layer1.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: -1, c: 1, d: 0, tx: 0, ty: 1))
        layer1.bounds = topContainerView.bounds.insetBy(dx: -topContainerView.bounds.size.width, dy: -topContainerView.bounds.size.height)
        topContainerView.layer.addSublayer(layer1)
        layer1.position = topContainerView.center

      
    }
    private func statusOfInitialOutlets() {
        buttonsStackView.isHidden = false
        totalDuration.isHidden = true
        currentDuration.isHidden = true
        playPauseButton.isHidden = true
        progressBar.isHidden = true
        likeCountLabel.isHidden = true
        commentCountLabel.isHidden = true
        bookmarkCountLabel.isHidden = true
        descriptionLabel.layer.zPosition = 1
        buttonsStackView.layer.zPosition = 1
        creditButton.layer.zPosition = 1
        socialMediaImage.layer.zPosition = 1
        menuButton.layer.zPosition = 1
        categoryName.layer.zPosition = 1
    }

    @objc private func playPauseButtonDidTapped() {
        isPlayPauseButtonSelected.toggle()
//        let imageName = isPlayPauseButtonSelected ? "play-icon" : "pause-icon"
//        buttonsTintColor(imageName: imageName, button: playPauseButton, tintColor: .white)
        
        if self.player?.timeControlStatus == .playing {
            buttonsTintColor(imageName: "play-icon", button: playPauseButton, tintColor: .white)
            self.player?.pause()
        } else {
            buttonsTintColor(imageName: "pause-icon", button: playPauseButton, tintColor: .white)
            self.player?.play()
        }
        
    }
    
    private func setObserverToPlayer() {
        let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsed in
            self.updatePlayerTime()
        })
    }
    private func updatePlayerTime() {
        guard let currentTime = self.player?.currentTime() else {return}
        guard let duration = self.player?.currentItem?.duration else {return}
        let currentTimeInSecond = CMTimeGetSeconds(currentTime)
        let durationTimeInSecond = CMTimeGetSeconds(duration)
        if self.isThumbSeek == false {
            self.progressBar.value = Float(currentTimeInSecond/durationTimeInSecond)
        }
     
        self.currentDuration.text = formatTime(seconds: currentTimeInSecond)
        self.totalDuration.text = " / \(formatTime(seconds: durationTimeInSecond))"
    }
    private func formatTime(seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) / 60) % 60
        let seconds = Int(seconds) % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    @objc func onTapToSlider() {
        self.isThumbSeek = true
        guard let duration = self.player?.currentItem?.duration else {return}
        let value = Float64(self.progressBar.value) * CMTimeGetSeconds(duration)
        if value.isNaN == false {
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            self.player?.seek(to: seekTime, completionHandler: { completed in
                if completed {
                    self.isThumbSeek = false
                }
            })
        }
    }
}
