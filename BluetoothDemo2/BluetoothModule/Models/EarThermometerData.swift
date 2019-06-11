//
//  EarThermometer.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/10/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

struct EarThermometerData {
    
    var recordTime: Date
    var temperatureData: TemperatureData
    
    init?(dict: [AnyHashable: Any]) {
        guard let earThermometer = dict["DeviceData"] as? [[String: Any]], let latest = earThermometer.last else {
            return nil
        }
        
        let year = Int(latest["year"] as? String ?? "")
        let month = Int(latest["month"] as? String ?? "")
        let day = Int(latest["day"] as? String ?? "")
        let hour = Int(latest["hour"] as? String ?? "")
        let min = Int(latest["min"] as? String ?? "")
        let sec = Int(latest["sec"] as? String ?? "")
        
        if  let temperatureString = latest["temperature"] as? String, let temperature = Double(temperatureString),
            let time = Date(year: year, month: month, day: day, hour: hour, min: min, sec: sec) {
            self.recordTime = time
            self.temperatureData = TemperatureData(temperature: temperature, unit: .C)
        } else {
            return nil
        }
    }
}

struct TemperatureData {
    var temperature: Double = 0.0
    var unit: TemperatureUnit = .F
    
    init(temperature: Double, unit: TemperatureUnit) {
        self.temperature = (unit == .C) ? convertC2F(temperature) : temperature
    }
    
    func convertC2F(_ C: Double) -> Double {
        return ((C * 1.8 + 32) * 10).rounded() / 10
    }
    
    enum TemperatureUnit {
        case C, F
        
        var symbol: String {
            switch self {
            case .C:
                return "\u{2103}"
            case .F:
                return "\u{2109}"
            }
        }
    }
}
