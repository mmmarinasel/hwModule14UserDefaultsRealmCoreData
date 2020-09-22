//
//  Weather.swift
//  hwRealm
//
//  Created by Марина Селезнева on 21.09.2020.
//

import Foundation
import UIKit
import RealmSwift

class Weather : Object {
    
    @objc dynamic var name: Date = NSDate.now
    @objc dynamic var temp: Double = 0
    @objc dynamic var info: String = ""
    @objc dynamic var status: String
    
    var mode: Character = "C"
    
    struct JsonWeather : Codable {
        var lat: Double
        var lon: Double
        var daily: [SingleDayJson]?
        
        struct SingleDayJson : Codable {
            var dt: Int64
            var wind_speed: Double
            var temp : JsonTemp
            var weather : [JsonWeatherType]?
            
            struct JsonTemp : Codable {
                var day: Double
            }
            
            struct JsonWeatherType : Codable {
                var main: String
                var description: String
            }
        }
    }
    
    enum Status : String{
        case Clouds = "Clouds"
        case Rain = "Rain"
        case Sunny = "Sunny"
        case Snow = "Snow"
        case Clear = "Clear"
    }
    
    var pic: UIImage? = nil
    
    init?(data: NSDictionary) {
        guard let name = data["dt"] as? Int64 else {
             return nil
        }
        
        guard let temp = data["temp"] as? NSDictionary else {
            return nil
        }
        
        guard let info = data["weather"] as? NSArray else {
            return nil
        }
        
        let timestamp: Double = Double(name)
        
        self.name = NSDate(timeIntervalSince1970: timestamp) as Date
        
        if let dayTemp = temp["day"] {
            self.temp = dayTemp as! Double
            self.temp = (self.temp - 273)
            self.temp = Double(self.temp * 10).rounded() / 10
        }
        
        if info.count > 0 {
            let currDict = info[0] as! NSDictionary
            if let infoMain = currDict["main"] {
                self.info = infoMain as! String
            }
        }
        
        switch self.info {
        case "Rain":
            self.status = Weather.Status.Rain.rawValue
            self.pic = UIImage(named: "Rain")
        case "Clouds":
            self.status = Weather.Status.Clouds.rawValue
            self.pic = UIImage(named: "Clouds")
        case "Sunny":
            self.status = Weather.Status.Sunny.rawValue
            self.pic = UIImage(named: "Sunny")
        case "Snow":
            self.status = Weather.Status.Snow.rawValue
            self.pic = UIImage(named: "Snow")
        default:
            self.status = Weather.Status.Clear.rawValue
            self.pic = UIImage(named: "Sunny")
        }
        
        
    }
    
    
    init(name: Date, temp: Double, info: String) {
        self.name = name
        self.temp = temp
        self.info = info
        //self.status = status
        switch self.info {
        case "Rain":
            self.status = Weather.Status.Rain.rawValue
            self.pic = UIImage(named: "Rain")
        case "Clouds":
            self.status = Weather.Status.Clouds.rawValue
            self.pic = UIImage(named: "Clouds")
        case "Sunny":
            self.status = Weather.Status.Sunny.rawValue
            self.pic = UIImage(named: "Sunny")
        case "Snow":
            self.status = Weather.Status.Snow.rawValue
            self.pic = UIImage(named: "Snow")
        default:
            self.status = Weather.Status.Clear.rawValue
            self.pic = UIImage(named: "Sunny")
        }
    }
        
     
    required init() {
        self.status = Status.Sunny.rawValue
    }
    
    static func getCollection(data: Data) -> [Weather] {
        var weatherCollection: [Weather] = []
        
        var instance : JsonWeather? = nil
        
        do {
            instance = try  JSONDecoder().decode(JsonWeather.self, from: data)
        } catch {
            print(error.localizedDescription)
            print(error.self)
        }
        
        if instance == nil { return weatherCollection }
        
        for day in instance!.daily! {
            //var currentDate: Double = Double(day.dt)
            var currentDate = NSDate(timeIntervalSince1970: Double(day.dt)) as Date
            var currentTemp = day.temp.day.rounded() - 273
            var currentWeatherType = ""
            if day.weather != nil && day.weather!.count > 0 {
                currentWeatherType = day.weather![0].main
            }
            
            var currentWeather: Weather = Weather(name: currentDate, temp: currentTemp, info: currentWeatherType)
            weatherCollection.append(currentWeather)
        }
        
        return weatherCollection
    }

    
    func changeMode(_ mode: Character) {
        if self.mode == mode { return }
        
        else if mode == "C" {
            self.temp = Double((self.temp - 32) * 5 / 9 * 10).rounded() / 10
        }
        else if mode == "F" {
            self.temp = Double((self.temp * 9 / 5 + 32 ) * 10).rounded() / 10
        }
        self.mode = mode
        
    }
    
}

