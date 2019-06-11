//
//  PulseOximeterData.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/10/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

struct PulseOximeterData {
    
    var pulseData: PulseData
    var oxygenData: OxygenData
    var recordTime: Date
    
    init?(dict: [AnyHashable: Any]) {
        guard let oxygenPulse = dict["OxygenPulse"] as? [AnyHashable: Any], let deviceData = oxygenPulse["DeviceData1"] as? [[String: Any]], let latest = deviceData.last else {
            return nil
        }
        
        let year = Int(latest["year"] as? String ?? "")
        let month = Int(latest["month"] as? String ?? "")
        let day = Int(latest["day"] as? String ?? "")
        let hour = Int(latest["hour"] as? String ?? "")
        let min = Int(latest["min"] as? String ?? "")
        let sec = Int(latest["sec"] as? String ?? "")
        
        if  let pulseString = latest["PulseRate"] as? String, let pulse = Double(pulseString),
            let oxygenString = latest["Oxygen"] as? String, let oxygen = Double(oxygenString),
            let time = Date(year: year, month: month, day: day, hour: hour, min: min, sec: sec) {
            self.recordTime = time
            self.pulseData = PulseData(pulse: pulse)
            self.oxygenData = OxygenData(oxygen: oxygen)
            
        } else {
            return nil
        }
    }
}

struct PulseData {
    var pulse: Double
}

struct OxygenData {
    var oxygen: Double
}
