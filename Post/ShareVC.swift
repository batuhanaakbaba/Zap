//
//  ShareVC.swift
//  Zap
//
//  Created by Batuhan Akbaba on 13.11.2023.
//

import UIKit
import FirebaseDatabase
import SnapKit
import AVKit
import FirebaseStorage

class ShareVC: UIViewController {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var creditTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var socialMediaTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var addPostButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addPostAction), for: .touchUpInside)
        return button
    }()
    
    lazy var activity: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView()
        act.style = .large
        return act
    }()
    
    var categories: [Category] = []
    var selectedCategories: [Category] = []
    private let cache = NSCache<NSString, NSArray>()
    private var selectedVideoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(addPostButton)
        view.addSubview(activity)
        addPostButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        activity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        DispatchQueue.main.async {
            self.getData()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        videoImageView.addGestureRecognizer(tapGesture)
        videoImageView.isUserInteractionEnabled = true
        
    }
    @objc func imageViewTapped() {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
            present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func addPostAction() {
        
        guard let credit = creditTextField.text,
              let urlOptional = urlTextField.text,
              let socialMedia = socialMediaTextField.text,
              let description = descriptionTextView.text else {
            return
        }
        let currentTimeInMillis = Int(Date().timeIntervalSince1970 * 1000)
        let selectedCategoryIDs = selectedCategories.map { $0.categoryId }
        activity.startAnimating()
        if let videoURL = self.selectedVideoURL {
  
            self.convertVideoToMP4(videoURL) { [weak self] convertedURL in
                if let convertedURL = convertedURL, let videoData = try? Data(contentsOf: convertedURL) {
                    let videoName = UUID().uuidString + ".mp4"
                    let videoRef = Storage.storage().reference().child("videos").child(videoName)
                    
                    videoRef.putData(videoData, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error occurred: \(error.localizedDescription)")
                        } else {
                            videoRef.downloadURL { (url, error) in
                                if let downloadURL = url {
//                                 REALTİME DATABASE CODES

                                    var video = [
                                        "credit": credit,
                                        "videoURL":downloadURL.absoluteString,
                                        "url": urlOptional,
                                        "socialMedia": socialMedia,
                                        "description": description,
                                        "date": currentTimeInMillis,
                                        "likeCount": 0,
                                        "commentCount": 0,
                                        "bookmarkCount": 0,
                                        "views":0
                                        
                                    ] as [String : Any]

                                    let videoReference = Database.database().reference().child("Videos").childByAutoId()
                                    
                                    videoReference.setValue(video) { (error, _) in
                                        if let error = error {
                                            print("Post kaydedilirken bir hata oluştu: \(error.localizedDescription)")
                                        } else {
                                            print("Post başarıyla kaydedildi!")
                                         
                                            let videoID = videoReference.key
                                            video["videoID"] = videoID

                                            var updates: [String: Any] = [:]

                                            for categoryID in selectedCategoryIDs {
                                                updates["/Videos/\(videoID ?? "")/categories/\(categoryID)"] = true
                                                updates["/Category-Videos/\(categoryID)/\(videoID ?? "")"] = true
                                            }

                                            Database.database().reference().updateChildValues(updates) { (error, _) in
                                                if let error = error {
                                                    print("Kategori ve video bilgileri güncellenirken bir hata oluştu: \(error.localizedDescription)")
                                                } else {
                                                    print("Kategori ve video bilgileri başarıyla güncellendi!")
                                                    self?.activity.stopAnimating()
                                                }
                                            }
                                        }
                                    }
                                } else if let error = error {
                                    print("Failed to get download URL: \(error.localizedDescription)")
                                }
                                
//                                REALTİME DATABASE CODES
                            }
                        }
                    }
                } else {
                    print("Failed to convert video to MP4")
                }
                self?.selectedVideoURL = nil
            }
        }
    }

    func getData() {
        
        if let cachedData = cache.object(forKey: "categories") as? [Category] {
            self.categories = cachedData
            self.collectionView.reloadData()
            return
        }

        let databaseReference = Database.database().reference().child("Category")

        let startValue = 0
        let endValue = 34

        let query = databaseReference.queryOrdered(byChild: "order")
                                       .queryStarting(atValue: startValue)
                                       .queryEnding(atValue: endValue)

        query.observeSingleEvent(of:.value) { [weak self] (snapshot, _) in
            
            guard let self = self else { return }

            if let snapshotValue = snapshot.value as? [String: Any] {
                let categoryArray = snapshotValue.values.compactMap { (value: Any) -> Category? in
                    guard let categoryData = value as? [String: Any],
                          let categoryName = categoryData["categoryName"] as? String,
                          let categoryImage = categoryData["categoryImage"] as? String,
                          let categoryId = categoryData["categoryId"] as? String else {
                        return nil
                    }
                    return Category(dictionary: categoryData)
                }
                let sortedCategories = categoryArray.sorted { $0.order < $1.order }

                self.cache.setObject(sortedCategories as NSArray, forKey: "categories")
                self.categories = sortedCategories
                self.collectionView.reloadData()
            }
        }

    }


}

extension ShareVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let countryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareCell", for: indexPath) as? ShareCell {
            cell = countryCell
            let category = categories[indexPath.row]
            countryCell.category = category
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ShareCell {
            if cell.isSelectedCategory {
                cell.isSelectedCategory = false
                if let index = selectedCategories.firstIndex(of: categories[indexPath.row]) {
                    selectedCategories.remove(at: index)
                }
            } else {
                cell.isSelectedCategory = true
                selectedCategories.append(categories[indexPath.row])
              
            }
           
        }
     
     
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width / 3 - 9 , height: size.height / 10 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension ShareVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func generateThumbnailFromVideo(_ videoURL: URL) -> UIImage? {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch {
            print("Failed to generate thumbnail: \(error)")
            return nil
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let mediaType = info[.mediaType] as? String {
            if mediaType == UTType.movie.identifier {
                if let videoURL = info[.mediaURL] as? URL {
                    videoImageView?.image = generateThumbnailFromVideo(videoURL)
                    selectedVideoURL = videoURL
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
  public func convertVideoToMP4(_ videoURL: URL, completion: @escaping (URL?) -> Void) {
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString)
            .appendingPathExtension("mp4")
        
        let asset = AVAsset(url: videoURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
            completion(nil)
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(outputURL)
            case .failed:
                if let error = exportSession.error {
                    print("Video conversion failed: \(error.localizedDescription)")
                }
                completion(nil)
            case .cancelled:
                print("Video conversion cancelled")
                completion(nil)
            default:
                completion(nil)
            }
        }
    }
}
