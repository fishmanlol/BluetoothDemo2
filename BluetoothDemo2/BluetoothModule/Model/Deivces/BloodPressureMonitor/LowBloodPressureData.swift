//
//  LowBloodPressureData.swift
//  BlueToothDemo1
//
//  Created by Yi Tong on 5/20/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//
import Foundation

class LowBloodPressureData: HealthData {
    
    var name: String = "blood pressure - diastolic"
    
    var transferName: String = "blood_pressure_diastolic"
    
    var value: Any?
    
    var time: Date?
    
    var unit: String? = "mmHG"
    
    init() {}
    
    init(value: Double) {
        
        self.value = value
        self.time = Date()
        
    }
    
    init?(dict: [AnyHashable: Any]) {
        guard let allData = dict["DeviceData"] as? [[String: Any]], let data = allData.last else { return nil }
        guard let lowPressure = Int(data["LowPressure"] as? String ?? "") else { return nil }
        
        let year = Int(data["year"] as? String ?? "")
        let month = Int(data["month"] as? String ?? "")
        let day = Int(data["day"] as? String ?? "")
        let hour = Int(data["hour"] as? String ?? "")
        let min = Int(data["min"] as? String ?? "")
        let sec = Int(data["sec"] as? String ?? "")
        
        
        if let time = Date(year: year, month: month, day: day, hour: hour, min: min, sec: sec) {
            self.value = lowPressure
            self.time = time
        }
    }
}
