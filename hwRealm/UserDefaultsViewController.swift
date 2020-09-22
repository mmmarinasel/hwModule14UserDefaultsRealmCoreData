//
//  UserDefaultsViewController.swift
//  hwRealm
//
//  Created by Марина Селезнева on 21.09.2020.
//

import UIKit

class UserDefaultsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBAction func changedName(_ sender: Any) {
        Persistence.shared.userName = nameTextField.text
    }
    @IBAction func changedSurname(_ sender: Any) {
        Persistence.shared.userSurname = surnameTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = Persistence.shared.userName
        surnameLabel.text = Persistence.shared.userSurname
    }
  
}
