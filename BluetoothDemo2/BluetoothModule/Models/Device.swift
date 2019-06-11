//
//  Device.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit

struct Device: Hashable, Codable {
    
    var name: String
    var type: Device.DeviceType
    var sources: [Source] = []
    var connected = false {
        didSet { print("\(name) is \(connected ? "connected" : "disconnected")") }
    }
    
    var fetchingState: FetchingState = .idle
    
    var number: String {
        return String(" NO: " + name.suffix(4) + " ")
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
    }
    
    init?(name: String) {
        self.name = name
        
        let prefix = name.prefix(4)
        
        switch prefix {
        case "SpO208":
            if name.prefix(6) == "SpO208"
        case "TEMP03":
            type = .earThermometer
        default:
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(Device.DeviceType.self, forKey: .type)
        self.sources = try container.decode([Source].self, forKey: .sources)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(sources, forKey: .sources)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, type, sources
    }
    
    enum FetchingState {
        case idle, fetching, failed(String), succeed
    }
    
    enum DeviceType: String, CaseIterable, Codable {
        case earThermometer, pulseOximeter, bloodPressure, scale, unkown
        
        var image: UIImage? {
            switch self {
            case .earThermometer:
                return UIImage.earThermometer
            case .pulseOximeter:
                return  UIImage.pulseOximeter
            case .bloodPressure:
                return UIImage.bloodPressure
            case .scale:
                return UIImage.scale
            default:
                return nil
            }
        }
        
        var disconnectedImage: UIImage? {
            switch self {
            case .earThermometer:
                return UIImage.earThermometerDisconnected
            case .pulseOximeter:
                return  UIImage.pulseOximeterDisconnected
            case .bloodPressure:
                return UIImage.bloodPressureDisconnected
            case .scale:
                return UIImage.scaleDisconnected
            default:
                return nil
            }
        }
        
        var name: String {
            
            switch self {
            case .earThermometer:
                return "Ear Thermometer"
            case .pulseOximeter:
                return "Pulse Oximeter"
            case .bloodPressure:
                return "Blood Pressure"
            case .scale:
                return "Electronic Scale"
            case .unkown:
                return "Unkown Device"
            }
            
        }
        
        var prefix: String {
            switch self {
            case .pulseOximeter:
                return "SpO208"
            case .earThermometer:
                return "TEMP03"
            case .scale:
                return "WT01"
            default:
                return String(name.prefix(6))
            }
        }
        
    }
    
    static func ==(left: Device, right: Device) -> Bool {
        return left.name == right.name
    }
}
