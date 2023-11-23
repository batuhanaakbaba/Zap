//
//  RealFeedViewController.swift
//  Zap
//
//  Created by Batuhan Akbaba on 1.11.2023.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backButton: UIButton!
    
    var selectedCategories: [Category] = []
    var videos: [Video] = []
    var idString = ""
    let videoUrls: [String] = ["http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4","http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4","http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4","http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",""]
    private var videoLoadCounter = 0
    private let videosToLoadAtOnce = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        backButton.layer.zPosition = 1
        view.bringSubviewToFront(backButton)
        getData()
//        view.bringSubviewToFront(menuButton)
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
//        if let cell = collectionView.visibleCells.first as? FeedCollectionViewCell {
//            cell.player?.play()
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
//        if let cell = collectionView.visibleCells.first as? FeedCollectionViewCell {
//            cell.pauseVideo()
//        }
    }
    @IBAction func backButtonDidTapped(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
             
            
    }
//    private func getData() {
//        for category in selectedCategories {
//            categoryVideosDatabase.child(category.categoryId).observe(.childAdded) { [weak self] snapshot in
//                guard let self = self else { return }
//
//                self.singleVideo(videoId: snapshot.key) { video in
//                    self.videos.append(video)
//
//                    video.categoryIds = [category.categoryId]
//
//                    self.videoLoadCounter += 1
//
//                    if self.videoLoadCounter >= self.videosToLoadAtOnce {
//                        DispatchQueue.main.async {
//                            self.collectionView.reloadData()
//                        }
//                        self.videoLoadCounter = 0
//                    }
//                }
//            }
//        }
//    }

    private func getData() {
        for category in selectedCategories {
            categoryVideosDatabase.child(category.categoryId).observe(.childAdded) { [weak self] snapshot in
                guard let self = self else { return }

                self.singleVideo(videoId: snapshot.key) { video in
                    video.categoryIds = [category.categoryId]
                    self.videos.append(video)
//                    print(video.videoId)
                    // Veri çekme işlemi tamamlandığında reloadData çağır
                    if self.videos.count >= self.videosToLoadAtOnce {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }


    private func singleVideo(videoId: String, completion: @escaping (Video) -> Void) {
        videosDatabase.child(videoId).observeSingleEvent(of: .value) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let newVideo = Video.transformVideo(dictionary: dict, key: snapshot.key)
                completion(newVideo)
            }
        }
    }

//    private func getData() {
//        for category in selectedCategories {
////            print("kategorilerin sayısı ve idsi: \(category.categoryId)")
//            categoryVideosDatabase.child(category.categoryId).observe(.childAdded) { snapshot in
//                self.singleVideo(videoId: snapshot.key) { video in
//                    self.videos.append(video)
////                    print("bir video çek: \(video.videoURL ?? "")")
//                    print("kategori ids: \(video.categoryIds)")
//                    // Videolar yüklendiğinde sayacı arttır
//                    self.videoLoadCounter += 1
//
//                    // Belirlenen sayıda video yüklendiyse, collectionView'i güncelle
//                    if self.videoLoadCounter >= self.videosToLoadAtOnce {
//                        self.collectionView.reloadData()
//                        self.videoLoadCounter = 0 // Sayaçı sıfırla
//                    }
//                }
//            }
//        }
//    }
//
//    private func singleVideo(videoId: String, completion: @escaping (Video) -> Void) {
//        videosDatabase.child(videoId).observeSingleEvent(of: .value) { snapshot in
//            if let dict = snapshot.value as? [String: Any] {
//                let newVideo = Video.transformVideo(dictionary: dict, key: snapshot.key)
//                completion(newVideo)
//            }
//        }
//    }
}
extension FeedViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCell", for: indexPath) as? FeedCollectionViewCell {
            cell = feedCell
            feedCell.reset() // Reset the cell before configuring with new data
            let video = videos[indexPath.row]
            
            if let categoryIds = video.categoryIds, !categoryIds.isEmpty {
                if let firstCategoryId = categoryIds.first,
                    let category = selectedCategories.first(where: { $0.categoryId == firstCategoryId }) {
                    feedCell.configure(with: video)
                    feedCell.videoPlayer(videoUrl: video.videoURL!, identifier: video.videoId!)
//                    print(video.videoId)
                    self.idString = video.videoId!
                    feedCell.categoryName.text = category.categoryName
                } else {
                    print("Video için geçerli bir kategori bulunamadı.")
                }
            } else {
                print("Video için kategori atanmamış.")
            }
//            if let categoryIds = video.categoryIds?.randomElement() {
//                let category = selectedCategories.first(where: { $0.categoryId == categoryIds })
//                feedCell.configure(with: video)
//                feedCell.videoPlayer(videoUrl: video.videoURL!, identifier: video.videoId!)
//                feedCell.categoryName.text = category?.categoryName
//            }
        }
        return cell
    }

      
            



    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        // Diğer hücrelerdeki oynatıcıları durdur
//        if let currentIndexPath = collectionView.indexPathsForVisibleItems.first,
//           currentIndexPath.row != indexPath.row,
//           let currentCell = collectionView.cellForItem(at: currentIndexPath) as? FeedCollectionViewCell {
//            currentCell.player?.pause()
//            currentCell.playerLayer?.removeFromSuperlayer()
//            currentCell.playerLayer = nil
//            currentCell.player = nil
//        }
//
//        // Mevcut hücredeki oynatıcıyı başlat
//        if let currentCell = cell as? FeedCollectionViewCell {
//            currentCell.player?.play()
//            print(self.idString)
//        }
//    }
//
//
//
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if let previousCell = cell as? FeedCollectionViewCell {
//            previousCell.pauseVideo()
//
//        }
//    }

        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if let feedCell = cell as? FeedCollectionViewCell {
                feedCell.playVideoIfNeeded()
    
            }
        }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let feedCell = cell as? FeedCollectionViewCell {
            feedCell.reset()

        }
    }

}
//extension FeedViewController: UIScrollViewDelegate {
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if let indexPath = collectionView.indexPathsForVisibleItems.first,
//           let cell = collectionView.cellForItem(at: indexPath) as? FeedCollectionViewCell {
//            cell.playVideoIfNeeded()
//            cell.updatePlayPauseButton()
//        }
//    }
//}
