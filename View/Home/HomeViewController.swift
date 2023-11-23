//
//  ViewController.swift
//  Zap
//
//  Created by Batuhan Akbaba on 19.10.2023.
//

import UIKit
import FirebaseDatabase
import SnapKit
import CoreData


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
    let activity: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView()
        act.style = .large
        return act
    }()

    @IBOutlet weak var firstView: UIView!
    var selectedCategories: [Category] = []
    var noCategoriesName = [String]()
    var noCategoriesImage = [String]()
    var categories: [Category] = []
    private let cache = NSCache<NSString, NSArray>()

    
    private var isSettingsMenuShown: Bool = false
    private var beginPoint: CGFloat = 0.0
    private var difference: CGFloat = 0.0
  
   

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if InternetManager.shared.isInternetActive() {
            getData()
        } else {
            getCoreData()
        }

        menuBackgroundAlphaView.isHidden = true
        allViewsGetShadow()
        collectionView.delegate = self
        collectionView.dataSource = self
        watchButton.layer.zPosition = 2
        collectionView.layer.zPosition = 2
        view.bringSubviewToFront(watchButton)
        updateWatchButtonVisibility()
        view.addSubview(activity)
        activity.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-300)
            make.centerX.equalToSuperview()
        }
      

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

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let feedVC = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
       
            feedVC.selectedCategories = selectedCategories
            self.navigationController?.pushViewController(feedVC, animated: true)

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

    private func getData() {
        DispatchQueue.main.async {
            self.activity.startAnimating()
        }
        

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
                          let _ = categoryData["categoryName"] as? String,
                          let _ = categoryData["categoryImage"] as? String,
                          let _ = categoryData["categoryId"] as? String else {
                        return nil
                    }
                    return Category(dictionary: categoryData)

                }
                let sortedCategories = categoryArray.sorted { $0.order < $1.order }
                self.activity.stopAnimating()
                self.cache.setObject(sortedCategories as NSArray, forKey: "categories")
                self.categories = sortedCategories
                self.collectionView.reloadData()
            }
        }

    }

    private func getCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryDM")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
                
               if let name = result.value(forKey: "categoryName") as? String {
                   self.noCategoriesName.append(name)
                }
                
                if let image = result.value(forKey: "categoryImage") as? String {
                    self.noCategoriesImage.append(image)
                }
                
                self.collectionView.reloadData()
            }
        } catch {
            
        }
    }

    
}

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if InternetManager.shared.isInternetActive() {
            return categories.count
        } else {
            return noCategoriesName.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let countryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell {
 
            
            if InternetManager.shared.isInternetActive() {
               
                let category = categories[indexPath.row]
                countryCell.configure(with: category.categoryName, categoryImageName: category.categoryImage)
                countryCell.category = category
            } else {
                
                let categoryName = noCategoriesName[indexPath.row]
                let categoryImage = noCategoriesImage[indexPath.row]
                countryCell.configure(with: categoryName, categoryImageName: categoryImage)
            }

            cell = countryCell
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if InternetManager.shared.isInternetActive() {
            
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
        } else {
            let alert = UIAlertController(title: "Error", message: "Please check your internet connection", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }

       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width / 3 - 9 , height: size.width / 4 )
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

let categories: [String] = ["News","Entertainment","Sport","Memes","Beauty","ASMR","Technology","Fashion","Startup","Business","Finance","Real Estate","Cars","Gaming","Science","Cars","Christianity","Food","Animals","Oddly Satisfying","Places","Music","Architecture","Travel","DIY","Art","Engineering","Funny","Interesting","️College","Cringe","Celebrities","Personel Growth","Shopping","ASMR"]
let categoriesImage: [String] = ["📰","🎪","🏈","💩","💅","💆‍♀️","💻","🦄","👠","💸","🏢","💸","🏡","🚗","🕹","🧪","🚗","✝️","🍕","🐶","🫠","📍","🎸","🏰","🏖️","🛠️","🎨","⚙️","🤣️","🤯","🎓","🫣","🤩","🪞","🛍️","💆‍♀️"]

//        let userDefaults = UserDefaults.standard
//
//          if userDefaults.bool(forKey: "hasLaunchedBefore") {
//              let storyboard = UIStoryboard(name: "Main", bundle: nil)
//              let feedVC = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
//              self.navigationController?.pushViewController(feedVC, animated: true)
//          } else {
//
//              let storyboard = UIStoryboard(name: "Main", bundle: nil)
//              let feedVC = storyboard.instantiateViewController(withIdentifier: "IntroductionViewController") as! IntroductionViewController
//
//              self.navigationController?.pushViewController(feedVC, animated: true)
//
//              userDefaults.set(true, forKey: "hasLaunchedBefore")
//              userDefaults.synchronize()
//          }
