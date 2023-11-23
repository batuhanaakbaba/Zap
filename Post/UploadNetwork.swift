//
//  UploadNetwork.swift
//  Zap
//
//  Created by Batuhan Akbaba on 17.11.2023.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import AVKit

class UploadNetwork {
    
    static let shared = UploadNetwork()
    
    public func uploadVideo(creditTextField: UITextField, urlTextField: UITextField, socialMediaTextField: UITextField, descriptionTextView: UITextView,selectedCategories: [Category] = [], activity: UIActivityIndicatorView, selectedVideoURL: URL?) {
        guard let credit = creditTextField.text,
              let urlOptional = urlTextField.text,
              let socialMedia = socialMediaTextField.text,
              let description = descriptionTextView.text else {
            return
        }
        let currentTimeInMillis = Int(Date().timeIntervalSince1970 * 1000)
        let selectedCategoryIDs = selectedCategories.map { $0.categoryId }
        activity.startAnimating()
        if let videoURL = selectedVideoURL {
  
            convertVideoToMP4(videoURL) { [weak self] convertedURL in
                if let convertedURL = convertedURL, let videoData = try? Data(contentsOf: convertedURL) {
                    let videoName = UUID().uuidString + ".mp4"
                    let videoRef = Storage.storage().reference().child("videos").child(videoName)
                    
                    videoRef.putData(videoData, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error occurred: \(error.localizedDescription)")
                        } else {
                            videoRef.downloadURL { (url, error) in
                                if let downloadURL = url {
//                                 REAL-TİME DATABASE CODES

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
                                                    activity.stopAnimating()    
                                                    
                                                }
                                            }
                                        }
                                    }
                                } else if let error = error {
                                    print("Failed to get download URL: \(error.localizedDescription)")
                                }
                                
//                                REAL-TİME DATABASE CODES
                            }
                        }
                    }
                } else {
                    print("Failed to convert video to MP4")
                }
                
            }
        }

     
    }
    
   func convertVideoToMP4(_ videoURL: URL, completion: @escaping (URL?) -> Void) {
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
