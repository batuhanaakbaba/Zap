//
//  LocationViewController.swift
//  Zap
//
//  Created by Batuhan Akbaba on 26.10.2023.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countryLabel: UILabel!
    
    var locations = ["United Kingdom","United States","Turkey","France","Germany","Italy","Spain","Russia","Canada","United Arab Emirates","Saudi Arabia","Australia"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarDesign()
        tableView.dataSource = self
        tableView.delegate = self

    }

    private func navigationBarDesign() {
        
        navigationItem.title = "Location"
        navigationController?.navigationBar.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
        view.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "MavenPro-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18)
        ]
        
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    }
    

}
extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "MavenPro-SemiBold", size: 16)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.black
        countryLabel.text = locations[indexPath.row]
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.clear
    }
}

