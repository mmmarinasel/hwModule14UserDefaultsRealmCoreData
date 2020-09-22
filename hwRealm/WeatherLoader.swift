//
//  WeatherLoader.swift
//  hwRealm
//
//  Created by Марина Селезнева on 21.09.2020.
//

import Foundation
import Alamofire
import SVProgressHUD

protocol WeatherDelegate {
    func loadedWeather(days: [Weather])
}

class WeatherLoader{
    var delegate: WeatherDelegate?
    
//    func loadWeather() {
//        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=55.850156&lon=37.479521&appid=261f3b02ebefbf1595fab5f0855df46f")!
//        let request = URLRequest(url: url)
//        SVProgressHUD.show()
//        let task = URLSession.shared.dataTask(with: request) {
//            data, response, error in
//            if let data = data,
//                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
//                let jsonDict = json as? NSDictionary {
//                var dayWeather: [Weather] = []
//
//                if let dailyArray = jsonDict["daily"] {
//                    for dayDict in dailyArray as! NSArray {
//                        if let weather = Weather(data: dayDict as! NSDictionary) {
//                            dayWeather.append(weather)
//                        }
//                    }
//                }
//
//                //let asd = Weather(data: data)
//
//                let dayWeather = Weather.getCollection(data: data)
//
//                DispatchQueue.main.async {
//                    self.delegate?.loadedWeather(days: dayWeather)
//                    SVProgressHUD.dismiss()
//                }
//            }
//        }
//        task.resume()
//    }
    
    func loadWeatherAlamofire() {
        SVProgressHUD.show()
        Alamofire.request("https://api.openweathermap.org/data/2.5/onecall?lat=57.850156&lon=18.479521&appid=261f3b02ebefbf1595fab5f0855df46f").responseJSON { response in
            if let objects = response.result.value,
                let jsonDict = objects as? NSDictionary {
                    var dayWeather: [Weather] = []
                    if let dailyArray = jsonDict["daily"] {
                        for dayDict in dailyArray as! NSArray {
                            if let weather = Weather(data: dayDict as! NSDictionary) {
                                dayWeather.append(weather)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.delegate?.loadedWeather(days: dayWeather)
                        SVProgressHUD.dismiss()
                    }
                }
            }
        }
    }

//"https://api.openweathermap.org/data/2.5/onecall?lat=55.850156&lon=37.479521&appid=261f3b02ebefbf1595fab5f0855df46f"
