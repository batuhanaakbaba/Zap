//
//  MoodWatchViewController.swift
//  Zap
//
//  Created by Batuhan Akbaba on 30.10.2023.
//

import UIKit

class MoodWatchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let categories: [String] = ["🕰️ Feeling nostalgic","✨ I need motivation","🤣 Make me laugh","🤯 Show me interesting things","🏖️ Let me explore beautiful places","🥰 Wholesome moments","🧘‍♀️ Relax"]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

    }

}
extension MoodWatchViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let countryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoodWatchCollectionViewCell", for: indexPath) as? MoodWatchCollectionViewCell {
            countryCell.configure(with: categories[indexPath.row])
            cell = countryCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width , height: size.height / 6)
    }
    
    
}
