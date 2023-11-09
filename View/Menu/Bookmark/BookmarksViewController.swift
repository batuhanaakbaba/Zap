//
//  BookmarksViewController.swift
//  Zap
//
//  Created by Batuhan Akbaba on 27.10.2023.
//

import UIKit

struct Item {
    var imageName: String
}

class BookmarksViewController: UIViewController {

    enum Mode {
        case view
        case select
    }
    @IBOutlet weak var collectionView: UICollectionView!
    var dictionarySelectedIndecPath: [IndexPath: Bool] = [:]
    var items: [Item] = [Item(imageName: "dwayne"),Item(imageName: "dwayne"),Item(imageName: "dwayne"),Item(imageName: "dwayne"),Item(imageName: "dwayne"),Item(imageName: "dwayne"),Item(imageName: "dwayne"),Item(imageName: "dwayne")]

    
    var mMode: Mode = .view {
      didSet {
          didSetMode()
      }
    }
    
    lazy var selectBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonClicked(_ :)))
        button.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "MavenPro-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ], for: .normal)
        return button
    }()
    lazy var deleteBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(didDeleteButtonClicked(_ :)))
        button.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor(red: 246/255, green: 90/255, blue: 90/255, alpha: 1.0),
            NSAttributedString.Key.font: UIFont(name: "MavenPro-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ], for: .normal)
       
        return button
    }()
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        button.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "MavenPro-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ], for: .normal)
       
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setupBarButtonItems()
        navigationBarDesign()

      
    }

    private func didSetMode() {
        switch mMode {
        case .view:
          for (key, value) in dictionarySelectedIndecPath {
            if value {
              collectionView.deselectItem(at: key, animated: true)
            }
          }
          
          dictionarySelectedIndecPath.removeAll()
          
          selectBarButton.title = "Select"
          navigationItem.leftBarButtonItem = nil
          collectionView.allowsMultipleSelection = false
        case .select:
            navigationItem.rightBarButtonItem = deleteBarButton
          navigationItem.leftBarButtonItem = cancelButton
          collectionView.allowsMultipleSelection = true
        }
    }
    private func navigationBarDesign() {
        
        navigationItem.title = "Bookmarks"
        navigationController?.navigationBar.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
        view.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "MavenPro-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18)
        ]
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)

    
    }

    private func setupBarButtonItems() {
      navigationItem.rightBarButtonItem = selectBarButton
    }
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
      mMode = mMode == .view ? .select : .view
    }
    @objc func cancelAction() {
      mMode = mMode == .select ? .view : .view
        navigationItem.rightBarButtonItem = selectBarButton
    }
    
    @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem) {
      var deleteNeededIndexPaths: [IndexPath] = []
      for (key, value) in dictionarySelectedIndecPath {
        if value {
          deleteNeededIndexPaths.append(key)
        }
      }
      
      for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
        items.remove(at: i.item)
      }
      
      collectionView.deleteItems(at: deleteNeededIndexPaths)
      dictionarySelectedIndecPath.removeAll()
    }

}
extension BookmarksViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookmarksCollectionViewCell", for: indexPath) as! BookmarksCollectionViewCell
        cell.bookmarksImage.image = UIImage(named: items[indexPath.item].imageName)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BookmarksReusableView", for: indexPath) as! BookmarksReusableView
            return headerViewCell
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width / 3 - 2, height: size.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      switch mMode {
      case .view:
       print("not selected")
      case .select:
        dictionarySelectedIndecPath[indexPath] = true
      }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
      if mMode == .select {
        dictionarySelectedIndecPath[indexPath] = false
      }
    }
    
}
