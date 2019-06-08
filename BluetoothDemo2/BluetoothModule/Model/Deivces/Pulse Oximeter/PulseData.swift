//
//  POData.swift
//  TestBlueTooth
//
//  Created by Yi Tong on 5/9/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

class PulseData: HealthData {
    
    var name: String = "heart rate"
    
    var transferName: String = "heart_rate"
    
    var value: Any?
    
    var time: Date?
    
    var unit: String? = "BPM"
    
    init() {}
    
    init(pulse: Double) {
        self.value = pulse
    }
    
    init?(data: [AnyHashable: Any]) {
        
        let pulseData: [String: Any]
        
        if let oxygenPulse = data["OxygenPulse"], let dict = oxygenPulse as? [AnyHashable: Any], let deviceData = dict["DeviceData1"] as? [[String: Any]], let firstData = deviceData.first {//Data come from pulse oximetor
            pulseData = firstData
        } else if let allData = data["DeviceData"] as? [[String: Any]], let lastData = allData.last{//Data come from blood pressure monitor
            pulseData = lastData
        } else {
            return nil
        }

        let year = Int(pulseData["year"] as? String ?? "")
        let month = Int(pulseData["month"] as? String ?? "")
        let day = Int(pulseData["day"] as? String ?? "")
        let hour = Int(pulseData["hour"] as? String ?? "")
        let min = Int(pulseData["min"] as? String ?? "")
        let sec = Int(pulseData["sec"] as? String ?? "")
        
        if let time = Date(year: year, month: month, day: day, hour: hour, min: min, sec: sec) {
            
            self.value = Int(pulseData["PulseRate"] as? String ?? "")
            self.time = time
            
        }
    }
}


