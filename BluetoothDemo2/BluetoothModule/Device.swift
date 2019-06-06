//
//  Device.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit

struct Device: Equatable {
    
    var name: String
    var imageName: String = ""
    var type: Device.DeviceType
    var sources: [Source] = []
    
    init(name: String, type: Device.DeviceType) {
        self.name = name
        self.type = type
    }
    
    enum DeviceType: String, CaseIterable, Codable {
        case earThermometer, pulseOximeter
        
        var prefix: String {
            switch self {
            case .pulseOximeter:
                return "SpO208"
            case .earThermometer:
                return "TEMP03"
            }
        }
        
    }
    
    static func ==(left: Device, right: Device) -> Bool {
        return left.name == right.name
    }
}

extension Device: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.type = try container.decode(Device.DeviceType.self, forKey: .type)
        self.sources = try container.decode([Source].self, forKey: .sources)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(type, forKey: .type)
        try container.encode(sources, forKey: .sources)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, imageName, type, sources
    }
    
}
