//
//  WeatherViewController.swift
//  hwRealm
//
//  Created by Марина Селезнева on 21.09.2020.
//

import UIKit
import RealmSwift

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    var daysWeather: [Weather] = []
    
    struct ModeButtons {
        var indexPath: IndexPath
        var cell: WeatherTableViewCell
        var celsiusButton: UIButton
        var fahrenheitButton: UIButton
    }
    
    var modeButtons: [ModeButtons] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let realm = try! Realm()
        
        let result = realm.objects(Weather.self)
        
        for r in result {
            daysWeather.append(r.self)
        }
        weatherTableView.reloadData()
        
        let loader = WeatherLoader()
        loader.delegate = self
        loader.loadWeatherAlamofire()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        var realm = try! Realm()
        
        let result = realm.objects(Weather.self)
        for r in result {
            try! realm.write {
                realm.delete(r)
            }
        }
        
        realm = try! Realm()
        
        for loaded in daysWeather {
            try! realm.write {
                realm.add(loaded)
            }
            
        }
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysWeather.count
    }
    
    @objc func setCelsium(sender: UIButton) {
        let buttonTag = sender.tag
        let weather = daysWeather[sender.tag]
        weather.changeMode("C")
    
        let indexPath = IndexPath(row: buttonTag, section: 0)
        let cell = weatherTableView.cellForRow(at: indexPath) as? WeatherTableViewCell
        
        
        if cell == nil { return }
        cell!.tempLabel.text = String(weather.temp)
    }
    
    @objc func setFahrenheit(sender: UIButton) {
        let buttonTag = sender.tag
        let weather = daysWeather[sender.tag]
        weather.changeMode("F")
        let indexPath = IndexPath(row: buttonTag, section: 0)
        let cell = weatherTableView.cellForRow(at: indexPath) as? WeatherTableViewCell

        if cell == nil { return }
        cell!.tempLabel.text = String(weather.temp)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherTableViewCell
        
        if cell.isCellSet() {
            updateCellValues(cell, indexPath: indexPath)
            return cell
        }
        cell.commit()
        let model = daysWeather[indexPath.row]
        
        let celsiusButton = UIButton()
        let fahrenheitButton = UIButton()
        
        celsiusButton.tag = indexPath.row
        fahrenheitButton.tag = indexPath.row
        
        let positionX = cell.frame.width * 2/3
        let positionY = cell.frame.height / 2
        let buttonWidth = cell.tempLabel.frame.width / 2
        
        celsiusButton.frame = CGRect(x: positionX - 25, y: positionY, width: buttonWidth, height: 25)
        fahrenheitButton.frame = CGRect(x: positionX + 10, y: positionY, width: buttonWidth, height: 25)
        
        celsiusButton.setTitle("C", for: .normal)
        celsiusButton.setTitleColor(.systemBlue, for: .normal)
        fahrenheitButton.setTitle("F", for: .normal)
        fahrenheitButton.setTitleColor(.systemBlue, for: .normal)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        if let date = dateFormatterGet.date(from: model.name.description) {
            cell.dayLabel.text = dateFormatterPrint.string(from: date)
        }
        
        
        
        celsiusButton.addTarget(self, action: #selector(setCelsium(sender:)), for: .touchUpInside)
        fahrenheitButton.addTarget(self, action: #selector(setFahrenheit(sender:)), for: .touchUpInside)
        cell.weatherImage.image = model.pic
        cell.tempLabel.text = String(model.temp)
        cell.btnCelsius = celsiusButton
        cell.btnFahrenheit = fahrenheitButton
        let modeBtns: ModeButtons = ModeButtons(indexPath:          indexPath,
                                                cell:               cell,
                                                celsiusButton:      celsiusButton,
                                                fahrenheitButton:   fahrenheitButton)
        
        modeButtons.append(modeBtns)
        cell.addSubview(celsiusButton)
        cell.addSubview(fahrenheitButton)
        return cell
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateCellValues(_ cell: WeatherTableViewCell,indexPath: IndexPath) {
       
        let info = daysWeather[indexPath.row]
        cell.tempLabel.text = String(info.temp)
        cell.weatherImage.image = info.pic
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        if let date = dateFormatterGet.date(from: info.name.description) {
            cell.dayLabel.text = dateFormatterPrint.string(from: date)
        }
        
        for v in cell.subviews {
            if v is UIButton {
                v.removeFromSuperview()
            }
        }
        
        
        if let idx = modeButtons.firstIndex(where: {$0.indexPath == indexPath}) {
            cell.btnCelsius = modeButtons[idx].celsiusButton
            cell.btnFahrenheit = modeButtons[idx].fahrenheitButton
            cell.addSubview(modeButtons[idx].celsiusButton)
            cell.addSubview(modeButtons[idx].fahrenheitButton)
        }
        
    }
    
}

extension WeatherViewController: WeatherDelegate {
    func loadedWeather(days: [Weather]) {
        self.daysWeather = days
        weatherTableView.reloadData()
    }
}
