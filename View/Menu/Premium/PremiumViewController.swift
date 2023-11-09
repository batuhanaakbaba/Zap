//
//  PremiumViewController.swift
//  Zap
//
//  Created by Batuhan Akbaba on 23.10.2023.
//

import UIKit

class PremiumViewController: UIViewController {

    @IBOutlet weak var subTitlesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarDesign()
        viewDesign()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 189/255, green: 1, blue: 0, alpha: 1.0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
   
    }
  
    
    private func viewDesign() {
        subTitlesView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        subTitlesView.layer.borderWidth = 1.0
        subTitlesView.layer.cornerRadius = 20
    }
    private func navigationBarDesign() {
        navigationItem.title = "Premium"
        navigationController?.navigationBar.backgroundColor = UIColor(red: 189/255, green: 1, blue: 0, alpha: 1.0)
        view.backgroundColor = UIColor(red: 189/255, green: 1, blue: 0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "MavenPro-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18)
        ]
        navigationController?.navigationBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    }
    
    @IBAction func premiumButtonDidTapped(_ sender: Any) {
        
    }
    
}
