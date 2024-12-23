//
//  MenuViewController.swift
//  Zap
//
//  Created by Batuhan Akbaba on 22.10.2023.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var premiumButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var bookmarksButton: UIButton!
    
    @IBOutlet weak var userIDLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        premiumButton.contentHorizontalAlignment = .left
        accountButton.contentHorizontalAlignment = .left
        locationButton.contentHorizontalAlignment = .left
        bookmarksButton.contentHorizontalAlignment = .left
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            userIDLabel.text = "User ID: \(userID)"
        } else {
            // Eğer kullanıcı kimliği bulunamazsa, atama işlemini gerçekleştir
            UserIdentificationManager.shared.assignUserIDIfNeeded()
        }
    
        navigationController?.navigationBar.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
    }

    @IBAction func premiumButtonDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let premiumVC = storyboard.instantiateViewController(withIdentifier: "PremiumViewController") as! PremiumViewController
     
        self.navigationController?.pushViewController(premiumVC, animated: true)
    }
    
    @IBAction func accountButtonDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let accountVC = storyboard.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
    
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
    
    @IBAction func locationButtonDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let locationVC = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
      
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    @IBAction func bookmarksButtonDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let locationVC = storyboard.instantiateViewController(withIdentifier: "BookmarksViewController") as! BookmarksViewController
      
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @IBAction func copyButtonDidTapped(_ sender: Any) {
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {
            print("Kullanıcı kimliği bulunamadı.")
            return
        }

        UIPasteboard.general.string = userID

        let alert = UIAlertController(title: "Kopyalandı", message: "Kullanıcı kimliği panoya kopyalandı.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
