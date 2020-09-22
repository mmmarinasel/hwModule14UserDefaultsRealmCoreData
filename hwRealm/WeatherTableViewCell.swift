//
//  WeatherTableViewCell.swift
//  hwRealm
//
//  Created by Марина Селезнева on 21.09.2020.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    var btnCelsius: UIButton? = nil
    var btnFahrenheit: UIButton? = nil
    
    private var isSet = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commit() {
        isSet = true
    }
    
    func isCellSet() -> Bool{
        return self.isSet
    }

}
