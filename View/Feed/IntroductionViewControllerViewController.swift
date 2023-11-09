//
//  FeedViewController.swift
//  Zap
//
//  Created by Batuhan Akbaba on 31.10.2023.
//

import UIKit

class IntroductionViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let introductions: [String] = ["Videos of current events.","The best videos of the internet.","Picked by humans.","Watch now.",""]
    let descriptions: [String] = ["Keep track of what's going on","Get rid of content chaos","Enjoy carefully curated videos","Don’t forget five stars :)",""]
    let colors: [UIColor] = [.greenColor,.turquoiseColor,.pinkColor,.black,.black]
    let tintColors: [UIColor] = [.black,.black,.white,.white,.black]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
extension IntroductionViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return introductions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroductionCollectionViewCell", for: indexPath) as? IntroductionCollectionViewCell {
            cell = feedCell
            feedCell.configure(with: introductions[indexPath.row], description: descriptions[indexPath.row], color: colors[indexPath.row],tintColor: tintColors[indexPath.row])
            feedCell.animationCell(indexPath: indexPath)
//
//            if indexPath.row == introductions.count - 1 {
//                feedCell.transitionButton.isHidden = false
//                feedCell.onTransitionButtonTapped = { [weak self] in
//                    guard let self = self else { return }
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
//                    let transition = CATransition()
//                    transition.duration = 0.5
//                    transition.type = CATransitionType.push
//                    transition.subtype = CATransitionSubtype.fromTop
//                    view.window!.layer.add(transition, forKey: kCATransition)
//                    vc.modalPresentationStyle = .fullScreen
//                    self.present(vc, animated: true, completion: nil)
//                }
//            } else {
//                feedCell.transitionButton.isHidden = true
//                feedCell.onTransitionButtonTapped = nil
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
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == introductions.count - 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromTop
            view.window!.layer.add(transition, forKey: kCATransition)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}
