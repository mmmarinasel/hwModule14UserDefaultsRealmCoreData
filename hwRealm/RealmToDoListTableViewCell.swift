//
//  RealmToDoListTableViewCell.swift
//  hwRealm
//
//  Created by Марина Селезнева on 21.09.2020.
//

import UIKit

class RealmToDoListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
