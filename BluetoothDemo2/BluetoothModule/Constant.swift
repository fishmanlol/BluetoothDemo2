//
//  Notification.swift
//  BluetoothDemo2
//
//  Created by Yi Tong on 6/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

struct Constant {
    
    struct NotificationName {
        static let deviceDidChanged = Notification.Name.init("devicesDidChanged")
    }
    
    struct Key {
        static let devicesKey = "devices"
    }
}
