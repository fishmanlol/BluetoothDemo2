//
//  Source.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

struct Source {
    let name: String
    let type: SourceType
    var data: [Any] = []
    
    init(name: String, type: SourceType) {
        self.name = name
        self.type = type
    }
    
    enum SourceType: String, Codable {
        case temperature
    }
}

extension Source: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(SourceType.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, type
    }
    
}
