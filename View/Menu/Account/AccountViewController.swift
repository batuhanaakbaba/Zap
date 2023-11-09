//
//  AccountViewController.swift
//  Zap
//
//  Created by Batuhan Akbaba on 25.10.2023.
//

import UIKit
import RxSwift
import RxCocoa

class AccountViewController: UIViewController {

    @IBOutlet weak var usernameTextField: HSUnderLineTextField!
    @IBOutlet weak var characterCounterLabel: UILabel!
    @IBOutlet weak var tooShortLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationBarDesign()
        reactiveTextfieldAction()
        keyboardDissmis()
       
        
    }

    private func navigationBarDesign() {
        
        navigationItem.title = "Account"
        navigationController?.navigationBar.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
        view.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "MavenPro-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18)
        ]
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        tooShortLabel.textColor = UIColor(red: 255/255, green: 90/255, blue: 90/255, alpha: 1.0)
    }
    
    private func reactiveTextfieldAction() {
        tooShortLabel.isHidden = true
        usernameTextField.rx.text.orEmpty
            .map { [weak self] text in
                let length = text.count

                self?.updateCharacterCountLabel(length: length)

                if length == 0 {
                    self?.doneButton.isEnabled = false
                    self?.doneButton.backgroundColor = .gray
                    self?.tooShortLabel.isHidden = true
                } else if length < 3 {
                    self?.tooShortLabel.isHidden = false
                    self?.doneButton.isEnabled = false
                    self?.doneButton.backgroundColor = .gray
                } else {
                    self?.tooShortLabel.isHidden = true
                    self?.doneButton.isEnabled = true
                    self?.doneButton.backgroundColor = .white
                }
                
                return length <= 15
            }
            .subscribe(onNext: { isValid in

            })
            .disposed(by: disposeBag)
        }
    
    private func updateCharacterCountLabel(length: Int) {
        characterCounterLabel.text = "\(length)/15"
    }
    
    private func keyboardDissmis() {
        usernameTextField.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
extension AccountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        return replacementText.count <= 15 && allowedCharacters.isSuperset(of: characterSet)
    }
    

}
