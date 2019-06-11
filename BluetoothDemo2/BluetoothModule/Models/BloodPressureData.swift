//
//  BloodPressureData.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/10/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

struct BloodPressureData {
    
    var diastolicData: PressureData
    var systolicData: PressureData
    var pulseData: PulseData
    var recordTime: Date
    
    init?(dict: [AnyHashable: Any]) {
        guard let bloodPressure = dict["DeviceData"] as? [[String: Any]], let latest = bloodPressure.last else {
            return nil
        }
        
        let year = Int(latest["year"] as? String ?? "")
        let month = Int(latest["month"] as? String ?? "")
        let day = Int(latest["day"] as? String ?? "")
        let hour = Int(latest["hour"] as? String ?? "")
        let min = Int(latest["min"] as? String ?? "")
        let sec = Int(latest["sec"] as? String ?? "")
        
        if let systolicString = latest["HighPressure"] as? String, let systolic = Double(systolicString),
            let diastolicString = latest["LowPressure"] as? String, let diastolic = Double(diastolicString),
            let pulseString = latest["PulseRate"] as? String, let pulse = Double(pulseString),
            let time = Date(year: year, month: month, day: day, hour: hour, min: min, sec: sec) {
            self.recordTime = time
            self.diastolicData = PressureData(value: diastolic)
            self.systolicData = PressureData(value: systolic)
            self.pulseData = PulseData(pulse: pulse)
        } else {
            return nil
        }
    }
}

struct PressureData {
    var value: Double
}
