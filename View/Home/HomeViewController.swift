//
//  ViewController.swift
//  Zap
//
//  Created by Batuhan Akbaba on 19.10.2023.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var hotsView: UIView!
    @IBOutlet weak var lastMonthView: UIView!
    @IBOutlet weak var twentyFourHoursView: UIView!
    @IBOutlet weak var randomView: UIView!
    @IBOutlet weak var wrapUpToDayView: UIView!
    @IBOutlet weak var moodWatchView: UIView!
    @IBOutlet weak var watchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var menuBackgroundAlphaView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingMenuConstraint: NSLayoutConstraint!

    var selectedCategories: [String] = []
    let categories: [String] = ["News","Entertainment","Sport","Memes","Beauty","ASMR","Technology","Fashion","Startup","Business","Finance","Real Estate","Cars","Gaming","Science","Cars","Christianity","Food","Animals","Oddly Satisfying","Places","Music","Architecture","Travel","DIY","Art","Engineering"
    ,"Funny","Interesting","️College","Cringe","Celebrities","Personel Growth","Shopping","ASMR"]
    let categoriesImage: [String] = ["📰","🎪","🏈","💩","💅","💆‍♀️","💻","🦄","👠","💸","🏢","💸","🏡","🚗","🕹","🧪","🚗","✝️","🍕","🐶","🫠","📍","🎸","🏰","🏖️","🛠️","🎨","⚙️","🤣️","🤯","🎓","🫣","🤩","🪞","🛍️","💆‍♀️"]
    
    private var isSettingsMenuShown: Bool = false
    private var beginPoint: CGFloat = 0.0
    private var difference: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBackgroundAlphaView.isHidden = true
        allViewsGetShadow()
        collectionView.delegate = self
        collectionView.dataSource = self
        watchButton.layer.zPosition = 2
        collectionView.layer.zPosition = 2
        view.bringSubviewToFront(watchButton)
        updateWatchButtonVisibility()
        navigationController?.navigationBar.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        allViewGradientLayer()
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
      return .topAttached
    }
    

    @IBAction func watchButtonDidTapped(_ sender: Any) {
//        let userDefaults = UserDefaults.standard
//
//          if userDefaults.bool(forKey: "hasLaunchedBefore") {
//              let storyboard = UIStoryboard(name: "Main", bundle: nil)
//              let feedVC = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
//              self.navigationController?.pushViewController(feedVC, animated: true)
//          } else {

              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              let feedVC = storyboard.instantiateViewController(withIdentifier: "IntroductionViewController") as! IntroductionViewController
              self.navigationController?.pushViewController(feedVC, animated: true)
//
//              userDefaults.set(true, forKey: "hasLaunchedBefore")
//              userDefaults.synchronize()
//          }
    }
    @IBAction func menuButtonDidTapped(_ sender: Any) {
   
        UIView.animate(withDuration: 0.2) {
            self.leadingMenuConstraint.constant = 10
            self.view.layoutIfNeeded()
        } completion: { [weak self] status in
            UIView.animate(withDuration: 0.1) {
                self?.leadingMenuConstraint.constant = 0
                self?.view.layoutIfNeeded()
            } completion: { [weak self] status in
                self?.menuBackgroundAlphaView.isHidden = false
                self?.menuButton.isHidden = true
                self?.watchButton.isHidden = true
                self?.isSettingsMenuShown = true
                
            }
        }
    }
    
    @IBAction func tappedOnMenuBackgroundView(_ sender: Any) {
        self.hideViewController()
        
    }
    private func updateWatchButtonVisibility() {
        watchButton.isHidden = selectedCategories.isEmpty
    }
    private func printSelectedCategories() {
        for category in selectedCategories {
            print(category)
        }
    }
    
    @IBAction func moodWatchDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let moodVC = storyboard.instantiateViewController(withIdentifier: "MoodWatchViewController") as! MoodWatchViewController
        
        if let sheet = moodVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }

        self.present(moodVC, animated: true)
    }
    
    
}
//MARK: VIEWS UI
extension HomeViewController {
    
    private func allViewGradientLayer() {
        wrapUpToDayGradientLayer()
        moodWatchGradientLayer()
    }
    private func wrapUpToDayGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 172/255, green: 100/255, blue: 152/255, alpha: 1.0).cgColor,
            UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1.0).cgColor,
        ]
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.frame = wrapUpToDayView.bounds
            gradientLayer.cornerRadius = 4
            wrapUpToDayView.layer.insertSublayer(gradientLayer, at: 0)
    }
    private func moodWatchGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 100/255, green: 103/255, blue: 172/255, alpha: 1.0).cgColor,
            UIColor(red: 24/255, green: 24/255, blue: 4/255, alpha: 1.0).cgColor,
        ]
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.frame = moodWatchView.bounds
            gradientLayer.cornerRadius = 4
            moodWatchView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func createShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 0.5
    }
    
    private func allViewsGetShadow() {
        createShadow(view: hotsView)
        createShadow(view: lastMonthView)
        createShadow(view: twentyFourHoursView)
        createShadow(view: randomView)
        createShadow(view: moodWatchView)
        createShadow(view: wrapUpToDayView)
        watchButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        watchButton.layer.borderWidth = 1.0
    }
    
}

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let countryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell {
            countryCell.configure(with: categories[indexPath.row], categoryImageName: categoriesImage[indexPath.row])
            cell = countryCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
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
        updateWatchButtonVisibility()
        printSelectedCategories()
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

extension HomeViewController {
    private func hideViewController() {
        
        UIView.animate(withDuration: 0.2) {
            self.leadingMenuConstraint.constant = 10
            self.view.layoutIfNeeded()
        } completion: { status in
            UIView.animate(withDuration: 0.2) {
                self.leadingMenuConstraint.constant = -240
                self.view.layoutIfNeeded()
            } completion: { status in
                self.menuBackgroundAlphaView.isHidden = true
                self.menuButton.isHidden = false
                self.isSettingsMenuShown = false
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                if self.selectedCategories.isEmpty {
                    self.watchButton.isHidden = true
                } else {
                    self.watchButton.isHidden = false
                }
            }

        }
    }
  
}
